part of 'bloc.dart';

class NotificationsState extends Equatable {
  final ApplicationMessage? message;
  final ServiceStatus status;

  final List<NotificationModel> notifications;

  const NotificationsState({
    this.status = ServiceStatus.initial,
    this.message,
    this.notifications = const [],
  });

  NotificationsState copyWith(
      {ServiceStatus? status,
      ApplicationMessage? message,
      List<NotificationModel>? notifications}) {
    return NotificationsState(
      status: status ?? this.status,
      message: message,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        notifications,
      ];
}
