import 'dart:async';

import 'package:fedha/data/models/auth/login/login_response.dart';
import 'package:fedha/data/services/local_data_cache.dart';
import 'package:fedha/data/services/service.dart';
import 'package:fedha/localization/app_prefs.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository._();
  static AuthenticationRepository instance = AuthenticationRepository._();
  final _controller = StreamController<AuthenticationStatus>.broadcast();
  final _prefs = service<AppPreferences>();

  AuthenticationStatus _status = AuthenticationStatus.unknown;
  String? authToken;
  User? _user;
  User? get user => _user;

  Stream<AuthenticationStatus> get stream async* {
    yield _status;
    yield* _controller.stream.asBroadcastStream();
  }

  AuthenticationStatus get status => _status;

  Future<void> login(LoginResponse loginResponse) async {
    final nextId = loginResponse.user.id;
    try {
      final cache = service<LocalDataCache>();
      final owner = await cache.loadLocalOwnerUserId();
      if (owner != null && owner != nextId) {
        // Different account on the same device — wipe previous local DB.
        await cache.clearAllUserData();
      }
      await cache.saveLocalOwnerUserId(nextId);
    } catch (_) {}

    authToken = loginResponse.accessToken;
    _user = loginResponse.user;
    _status = AuthenticationStatus.authenticated;
    _controller.add(_status);
  }

  _clearInfo() async {
    _prefs.removeUser();
  }

// TODO check stream close side effects
  void logout() async {
    try {
      await service<LocalDataCache>().clearAllUserData();
    } catch (_) {}
    await _clearInfo();
    authToken = null;
    _status = AuthenticationStatus.unauthenticated;
    _user = null;
    _controller.add(_status);
  }
}
