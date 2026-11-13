import 'package:dio/dio.dart';
import 'package:fedha/data/error/failure.dart';

class ErrorHandler {
  final DioException error;

  ErrorHandler(this.error);

  Failure handle() {
    final data = error.response?.data;
    final nestedMessage = _extractMessage(data);

    final statusCode = error.response?.statusCode;

    // Hosting firewall (Imunify360) blocked this network's IP before the
    // request reached the API.
    final rawBody = data is String ? data : (nestedMessage ?? '');
    if (rawBody.toLowerCase().contains('imunify')) {
      return Failure(
        error: "We couldn't reach FedhaTrac from this network. "
            "Switch between Wi-Fi and mobile data (or turn off any VPN) "
            "and try again. If it continues, contact support.",
        code: statusCode,
      );
    }

    if (nestedMessage != null && nestedMessage.isNotEmpty) {
      return Failure(
        error: nestedMessage,
        code: statusCode,
        precondition: data is Map ? data["precondition"] : null,
        description: data is Map ? data["description"] : null,
        value: data is Map ? data["value"] : null,
      );
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Failure(error: "Request timeout!", code: statusCode);
      case DioExceptionType.cancel:
        return Failure(error: 'Request canceled', code: statusCode);
      case DioExceptionType.badResponse:
        switch (statusCode) {
          case 400:
            return Failure(error: 'Something went wrong', code: statusCode);
          case 401:
            return Failure(error: 'Unauthorized', code: statusCode);
          case 403:
            return Failure(error: 'Forbidden', code: statusCode);
          case 404:
            return Failure(error: 'Resource not found', code: statusCode);
          case 406:
            return Failure(error: 'Invalid OTP entered', code: statusCode);
          case 429:
            return Failure(error: 'Too many requests', code: statusCode);
          case 500:
            return Failure(
              error: 'An error occured! Our team is resolving this!',
              code: statusCode,
            );
          case 412:
            return Failure(
              error: data is Map ? (data["error"]?.toString() ?? 'Error') : 'Error',
              code: statusCode,
              precondition: data is Map ? data["precondition"] : null,
              description: data is Map ? data["description"] : null,
              value: data is Map ? data["value"] : null,
            );
          default:
            return Failure(error: 'Error: $statusCode', code: statusCode);
        }
      default:
        print(this.error);
        return Failure(error: 'Network error');
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is! Map) return null;
    if (data['message'] is String) return data['message'] as String;
    final error = data['error'];
    if (error is Map && error['message'] is String) {
      return error['message'] as String;
    }
    if (error is String) return error;
    return null;
  }
}
