// ignore_for_file: public_member_api_docs, sort_constructors_first
class Failure implements Exception {
  final String error;
  final int? code;
  final Exception? exception;
  final StackTrace? stackTrace;
  final String? value;
  final String? description;
  final String? precondition;

  Failure(
      {required this.error,
      this.code,
      this.exception,
      this.stackTrace,
      this.value,
      this.description,
      this.precondition});

  @override
  String toString() {
    return 'Failure(error: $error, code: $code, exception: $exception, stackTrace: $stackTrace, value: $value, description: $description, precondition: $precondition)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Failure &&
        other.error == error &&
        other.code == code &&
        other.exception == exception;
  }

  @override
  int get hashCode {
    return error.hashCode ^ code.hashCode ^ exception.hashCode;
  }
}
