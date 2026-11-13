import 'dart:async';
import 'dart:collection';

import 'package:dio/dio.dart';

/// Limits concurrent API calls and retries HTTP 429 using Retry-After.
/// Home/dashboard loads were firing many parallel GETs and exhausting the
/// API budget (~60/min), which blanked most of the UI.
class RateLimitInterceptor extends Interceptor {
  RateLimitInterceptor(this._dio);

  final Dio _dio;

  static const int maxConcurrent = 2;
  static const int maxRetries = 3;

  int _active = 0;
  final Queue<Completer<void>> _waiters = Queue();
  DateTime? _cooldownUntil;

  Future<void> _acquire() async {
    while (_active >= maxConcurrent) {
      final c = Completer<void>();
      _waiters.add(c);
      await c.future;
    }
    _active++;
  }

  void _release() {
    _active = (_active - 1).clamp(0, 1000);
    if (_waiters.isNotEmpty) {
      _waiters.removeFirst().complete();
    }
  }

  Future<void> _waitCooldown() async {
    final until = _cooldownUntil;
    if (until != null && DateTime.now().isBefore(until)) {
      await Future.delayed(until.difference(DateTime.now()));
    }
  }

  static const _acquiredKey = '_rate_limit_acquired';

  void _safeRelease(RequestOptions options) {
    if (options.extra[_acquiredKey] == true) {
      options.extra[_acquiredKey] = false;
      _release();
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      await _waitCooldown();
      await _acquire();
      options.extra[_acquiredKey] = true;
      handler.next(options);
    } catch (e, st) {
      _safeRelease(options);
      handler.reject(
        DioException(requestOptions: options, error: e, stackTrace: st),
      );
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _safeRelease(response.requestOptions);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    _safeRelease(err.requestOptions);

    if (err.response?.statusCode != 429) {
      handler.next(err);
      return;
    }

    final retries = (err.requestOptions.extra['rate_limit_retries'] as int?) ?? 0;
    if (retries >= maxRetries) {
      handler.next(err);
      return;
    }

    final header = err.response?.headers.value('retry-after');
    final seconds = (int.tryParse(header ?? '') ?? 8).clamp(1, 60);
    _cooldownUntil = DateTime.now().add(Duration(seconds: seconds));

    await Future.delayed(Duration(seconds: seconds));

    try {
      final opts = err.requestOptions;
      opts.extra['rate_limit_retries'] = retries + 1;
      final response = await _dio.fetch(opts);
      handler.resolve(response);
    } catch (_) {
      handler.next(err);
    }
  }
}
