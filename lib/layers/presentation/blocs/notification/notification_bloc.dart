import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pharmacy_dashboard/layers/data/models/notification/notification.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/notification_repository.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/notification/add_notification.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/notification/get_notifications.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<NotificationsFetched>(_mapNotificationsFetched);
    on<NotificationAdded>(_mapNotificationAdded);
  }

  final _getNotificationsUseCase = GetNotificationsUseCase(
      notificationsRepository: NotificationRepositoryImplementation());
  final _addNotificationUseCase = AddNotificationUseCase(
      notificationRepository: NotificationRepositoryImplementation());
  FutureOr<void> _mapNotificationsFetched(
      NotificationsFetched event, Emitter<NotificationState> emit) async {
    final result = await _getNotificationsUseCase(event.getNotificationsParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(
            notificationsFetchingStatus: NotificationsFetchingStatus.failed));
      },
      (response) async {
        emit(state.copyWith(
          notificationsFetchingStatus: NotificationsFetchingStatus.success,
          notifications: response.notifications,
          totalNotificationsNumber: response.total,
        ));
      },
    );
  }

  FutureOr<void> _mapNotificationAdded(
      NotificationAdded event, Emitter<NotificationState> emit) async {
    emit(state.copyWith(
        notificationsFetchingStatus: NotificationsFetchingStatus.loading));
    final result = await _addNotificationUseCase(event.addNotificationParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(
            addingNotificationStatus: AddingNotificationStatus.failed));
      },
      (notification) async {
        final notifications = List.of(state.notifications)
          ..insert(0, notification);
        emit(state.copyWith(
          addingNotificationStatus: AddingNotificationStatus.success,
          notifications: notifications,
        ));
      },
    );
    emit(state.copyWith(
      notificationsFetchingStatus: NotificationsFetchingStatus.success,
      addingNotificationStatus: AddingNotificationStatus.initial,
    ));
  }
}
