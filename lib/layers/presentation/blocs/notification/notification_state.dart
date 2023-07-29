part of 'notification_bloc.dart';

enum NotificationsFetchingStatus { initial, loading, success, failed }

enum AddingNotificationStatus { initial, success, failed }

@immutable
class NotificationState {
  final NotificationsFetchingStatus notificationsFetchingStatus;
  final AddingNotificationStatus addingNotificationStatus;
  final List<NotificationModel> notifications;
  final int totalNotificationsNumber;

  const NotificationState({
    this.notificationsFetchingStatus = NotificationsFetchingStatus.initial,
    this.addingNotificationStatus = AddingNotificationStatus.initial,
    this.notifications = const [],
    this.totalNotificationsNumber = 0,
  });

  NotificationState copyWith({
    NotificationsFetchingStatus? notificationsFetchingStatus,
    AddingNotificationStatus? addingNotificationStatus,
    List<NotificationModel>? notifications,
    int? totalNotificationsNumber,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      notificationsFetchingStatus:
          notificationsFetchingStatus ?? this.notificationsFetchingStatus,
      addingNotificationStatus:
          addingNotificationStatus ?? this.addingNotificationStatus,
      totalNotificationsNumber:
          totalNotificationsNumber ?? this.totalNotificationsNumber,
    );
  }
}
