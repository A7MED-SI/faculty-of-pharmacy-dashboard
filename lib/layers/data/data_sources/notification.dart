import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'package:pharmacy_dashboard/core/constants/api/api_urls.dart';
import 'package:pharmacy_dashboard/core/unified_api/delete_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/get_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/handling_response.dart';
import 'package:pharmacy_dashboard/core/unified_api/printing.dart';

import '../../../core/global_functions/global_purpose_functions.dart';
import '../models/notification/notification.dart';

class NotificationDataSource extends Printing with HandlingResponse {
  NotificationDataSource() : super(requestName: 'Adding Notification');
  Future<List<NotificationModel>> getNotifications(
      {Map<String, dynamic>? queryParams}) async {
    final getApi = GetApi<List<NotificationModel>>(
      uri: ApiUris.getNotificationsUri(queryParams: queryParams),
      fromJson: (json) {
        final List<dynamic> notificationsJson =
            jsonDecode(json)['data']['notifications'] as List<dynamic>;

        return notificationsJson
            .map<NotificationModel>(
                (subJson) => NotificationModel.fromJson(subJson))
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

  Future<NotificationModel> addNotification({
    required Map<String, String> fields,
    required Uint8List image,
    required String imageName,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      ApiUris.addNotificationUri(),
    );
    request.headers.addAll({
      HttpHeaders.authorizationHeader:
          "Bearer ${GlobalPurposeFunctions.getAccessToken()}",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      HttpHeaders.acceptHeader: "application/json"
    });
    request.files.add(http.MultipartFile.fromBytes(
      'image',
      image,
      filename: imageName,
    ));
    request.fields.addAll(fields);
    // ignore: unused_local_variable
    final response = await request.send();
    final bodyString = await response.stream.bytesToString();
    print(
        'the response from add notification is ${response.statusCode} \n the response body is \n $bodyString');
    if (response.statusCode == 200) {
      return NotificationModel.fromJson(
          jsonDecode(bodyString)['data']['notification']);
    }
    Exception exception = getException(
      statusCode: response.statusCode,
      errorMessage: jsonDecode(bodyString)['message'],
    );
    throw (exception);
  }

  Future<NotificationModel> showNotification(
      {Map<String, dynamic>? queryParams, required int notificationId}) async {
    final getApi = GetApi<NotificationModel>(
      uri: ApiUris.showNotificationUri(notificationId: notificationId),
      fromJson: (json) {
        return NotificationModel.fromJson(
            jsonDecode(json)['data']['notification']);
      },
      requestName: 'Show Notification',
    );
    return await getApi.callRequest();
  }
}
