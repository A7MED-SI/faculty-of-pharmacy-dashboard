part of 'notification_bloc.dart';

enum NotificationsFetchingStatus { initial, loading, success, failed }

enum AddingNotificationStatus { initial, success, failed }

@immutable
class NotificationState {
  final NotificationsFetchingStatus notificationsFetchingStatus;
  final AddingNotificationStatus addingNotificationStatus;
  final List<NotificationModel> notifications;

  const NotificationState({
    this.notificationsFetchingStatus = NotificationsFetchingStatus.initial,
    this.addingNotificationStatus = AddingNotificationStatus.initial,
    this.notifications = const [],
  });

  NotificationState copyWith({
    NotificationsFetchingStatus? notificationsFetchingStatus,
    AddingNotificationStatus? addingNotificationStatus,
    List<NotificationModel>? notifications,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      notificationsFetchingStatus:
          notificationsFetchingStatus ?? this.notificationsFetchingStatus,
      addingNotificationStatus:
          addingNotificationStatus ?? this.addingNotificationStatus,
    );
  }
}
