part of 'notification_bloc.dart';

enum NotificationsFetchingStatus { initial, loading, success, failed }

enum AddingNotificationStatus { initial, success, failed }

@immutable
class NotificationState {
  final NotificationsFetchingStatus notificationsFetchingStatus;
  final AddingNotificationStatus addingNotificationStatus;
  final List<NotificationModel> notifications;
  final int totalNotificationsNumber;
  final String? errorMessage;

  const NotificationState({
    this.notificationsFetchingStatus = NotificationsFetchingStatus.initial,
    this.addingNotificationStatus = AddingNotificationStatus.initial,
    this.notifications = const [],
    this.totalNotificationsNumber = 0,
    this.errorMessage,
  });

  NotificationState copyWith({
    NotificationsFetchingStatus? notificationsFetchingStatus,
    AddingNotificationStatus? addingNotificationStatus,
    List<NotificationModel>? notifications,
    int? totalNotificationsNumber,
    String? errorMessage,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      notificationsFetchingStatus:
          notificationsFetchingStatus ?? this.notificationsFetchingStatus,
      addingNotificationStatus:
          addingNotificationStatus ?? this.addingNotificationStatus,
      totalNotificationsNumber:
          totalNotificationsNumber ?? this.totalNotificationsNumber,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
