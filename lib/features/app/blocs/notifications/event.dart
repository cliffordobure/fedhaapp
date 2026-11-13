part of 'bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class StartNotifications extends NotificationsEvent {
  /// When true, shows the loading spinner even if cache exists.
  final bool forceLoader;

  const StartNotifications({this.forceLoader = false});

  @override
  List<Object?> get props => [forceLoader];
}

class ReadNotification extends NotificationsEvent {
  final int id;
  const ReadNotification({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteNotification extends NotificationsEvent {
  final int id;
  const DeleteNotification({required this.id});

  @override
  List<Object?> get props => [id];
}
