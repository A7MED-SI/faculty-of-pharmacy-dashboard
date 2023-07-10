import 'dart:convert';

import 'package:pharmacy_dashboard/core/constants/api/api_urls.dart';
import 'package:pharmacy_dashboard/core/unified_api/delete_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/get_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/post_api.dart';

import '../models/Notification/Notification.dart';

class NotificationDataSource {
  Future<List<Notification>> getNotifications(
      {Map<String, dynamic>? queryParams}) async {
    final getApi = GetApi<List<Notification>>(
      uri: ApiUris.getNotificationsUri(queryParams: queryParams),
      fromJson: (json) {
        final List<dynamic> notificationsJson =
            jsonDecode(json)['data']['notifications'] as List<dynamic>;

        return notificationsJson
            .map<Notification>((subJson) => Notification.fromJson(subJson))
            .toList();
      },
      requestName: "Get All Notifications",
    );
    return await getApi.callRequest();
  }

  Future<bool> deleteNotification({required int notificationId}) async {
    final deleteApi = DeleteApi<bool>(
      uri: ApiUris.deleteNotificationUri(notificationId: notificationId),
      fromJson: (json) {
        return jsonDecode(json)['success'];
      },
      requestName: 'Delete Notification',
    );
    return await deleteApi.callRequest();
  }

  Future<Notification> addNotification(
      {required Map<String, dynamic> body}) async {
    final postApi = PostApi<Notification>(
      uri: ApiUris.addNotificationUri(),
      fromJson: (json) {
        return Notification.fromJson(jsonDecode(json)['data']['notification']);
      },
      requestName: 'Add Notification',
      body: body,
    );
    return await postApi.callRequest();
  }

  Future<Notification> showNotification(
      {Map<String, dynamic>? queryParams, required int notificationId}) async {
    final getApi = GetApi<Notification>(
      uri: ApiUris.showNotificationUri(notificationId: notificationId),
      fromJson: (json) {
        return Notification.fromJson(jsonDecode(json)['data']['notification']);
      },
      requestName: 'Show Notification',
    );
    return await getApi.callRequest();
  }
}
