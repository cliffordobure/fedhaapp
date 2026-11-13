import 'package:equatable/equatable.dart';
import 'package:fedha/data/models/application_message.dart';
import 'package:fedha/data/models/notifications/notifications.dart';
import 'package:fedha/data/services/service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'state.dart';
part 'event.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  late NotificationsService notificationsService;

  NotificationsBloc() : super(const NotificationsState()) {
    notificationsService = service<NotificationsService>();

    on<StartNotifications>(_onStart);
    on<ReadNotification>(_onRead);
    on<DeleteNotification>(_onDelete);
  }

  Future<void> _onStart(
    StartNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    final hasCache = state.notifications.isNotEmpty;
    // Avoid full-screen loader when we already have data — refresh quietly.
    if (!hasCache || event.forceLoader) {
      emit(state.copyWith(status: ServiceStatus.loading));
    }

    final res = await notificationsService.fetchNotifications();
    res.when(
      onError: (error) {
        // Keep cached list if refresh fails.
        if (hasCache) {
          emit(state.copyWith(status: ServiceStatus.loadingSuccess));
          return;
        }
        emit(state.copyWith(
          status: ServiceStatus.loadingFailure,
          message: ApplicationMessage.fromFailure(error),
        ));
      },
      onSuccess: (data) => emit(state.copyWith(
        status: ServiceStatus.loadingSuccess,
        notifications: data,
      )),
    );
  }

  Future<void> _onRead(
    ReadNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    // Optimistic local update — no full reload.
    final updated = state.notifications
        .map((n) => n.id == event.id ? n.copyWith(status: 1) : n)
        .toList(growable: false);
    emit(state.copyWith(
      status: ServiceStatus.loadingSuccess,
      notifications: updated,
    ));

    final res = await notificationsService.readNotification(event.id);
    res.when(
      onError: (error) {
        debugPrint(error.error);
        // Soft refresh in background without loader.
        add(const StartNotifications());
      },
      onSuccess: (_) {},
    );
  }

  Future<void> _onDelete(
    DeleteNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    final previous = state.notifications;
    final updated = previous
        .where((n) => n.id != event.id)
        .toList(growable: false);
    emit(state.copyWith(
      status: ServiceStatus.loadingSuccess,
      notifications: updated,
    ));

    final res = await notificationsService.deleteNotification(event.id);
    res.when(
      onError: (error) {
        debugPrint(error.error);
        // Restore list and soft-refresh.
        emit(state.copyWith(
          status: ServiceStatus.loadingSuccess,
          notifications: previous,
        ));
        add(const StartNotifications());
      },
      onSuccess: (_) {},
    );
  }
}
