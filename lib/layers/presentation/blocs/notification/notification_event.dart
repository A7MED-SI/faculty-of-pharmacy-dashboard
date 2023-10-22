part of 'notification_bloc.dart';

@immutable
abstract class NotificationEvent {}

class NotificationsFetched extends NotificationEvent {
  final GetNotificationsParams getNotificationsParams;

  NotificationsFetched({required this.getNotificationsParams});
}

class NotificationAdded extends NotificationEvent {
  final AddNotificationParams addNotificationParams;

  NotificationAdded({required this.addNotificationParams});
}

class NotificationDeleted extends NotificationEvent {
  final int notificationId;

  NotificationDeleted({required this.notificationId});
}
