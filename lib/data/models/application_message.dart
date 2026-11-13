import 'package:equatable/equatable.dart';
import 'package:fedha/data/error/failure.dart';

enum ApplicationMessageType { error, warning, success, info }

class ApplicationMessage extends Equatable {
  final String message;
  final ApplicationMessageType type;

  const ApplicationMessage({required this.message, required this.type});

  factory ApplicationMessage.fromFailure(Failure error) {
    return ApplicationMessage(
        message: error.error, type: ApplicationMessageType.error);
  }
  factory ApplicationMessage.success(String message) => ApplicationMessage(
      message: message, type: ApplicationMessageType.success);
  factory ApplicationMessage.error(String message) =>
      ApplicationMessage(message: message, type: ApplicationMessageType.error);

  @override
  List<Object?> get props => [message, type];
}
