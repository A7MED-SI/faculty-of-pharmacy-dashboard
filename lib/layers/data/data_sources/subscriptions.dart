import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:pharmacy_dashboard/core/constants/api/api_urls.dart';
import 'package:pharmacy_dashboard/core/unified_api/delete_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/get_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/post_api.dart';
import 'package:pharmacy_dashboard/layers/data/models/subscription/subscription.dart';

import '../../../core/global_functions/global_purpose_functions.dart';
import '../../../core/unified_api/printing.dart';
import '../../../core/unified_api/handling_response.dart';

import 'package:http/http.dart' as http;
class SubscriptionsDataSource extends Printing with HandlingResponse{
  SubscriptionsDataSource()
      : super(requestName: 'Make Subs As Printed');
  Future<SubscriptionsResponse> getSubscriptions(
      {Map<String, dynamic>? queryParams}) async {
    final getApi = GetApi<SubscriptionsResponse>(
      uri: ApiUris.getSubscriptionsUri(queryParams: queryParams),
      fromJson: (json) {
        return SubscriptionsResponse.fromJson(jsonDecode(json)['data']);
      },
      requestName: "Get All Subscrioptions",
    );
    return await getApi.callRequest();
  }

  Future<bool> deleteSubscription({required int subscriptionId}) async {
    final deleteApi = DeleteApi(
      uri: ApiUris.deleteSubscription(subscriptionId: subscriptionId),
      fromJson: (json) {
        return jsonDecode(json)['success'];
      },
      requestName: 'Delete Subscription',
    );
    return await deleteApi.callRequest();
  }

  Future<bool> addSubscriptionGroup(
      {required Map<String, dynamic> body}) async {
    final postApi = PostApi(
      uri: ApiUris.addSubscriptionGroupUri(),
      fromJson: (json) {
        return jsonDecode(json)['success'];
      },
      requestName: 'Add Subscription Group',
      body: body,
    );
    return await postApi.callRequest();
  }
  Future<bool> makeSubsAsPrinted({required List<int> subsIds}) async {
    final Map<String, dynamic> body = {
      'subscription_ids': subsIds,
    };
    final request = http.Request('POST', ApiUris.makeAsPrintedUri());
    request.headers.addAll({
      HttpHeaders.authorizationHeader:
          "Bearer ${GlobalPurposeFunctions.getAccessToken()}",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json"
    });
    request.body = jsonEncode(body);
    final response = await request.send().timeout(const Duration(seconds: 15));
    final bodyString = await response.stream.bytesToString();
    log(bodyString);
    if (response.statusCode == 200) {
      return jsonDecode(bodyString)['success'];
    }
    Exception exception = getException(
      statusCode: response.statusCode,
      errorMessage: jsonDecode(bodyString)['message'],
    );
    throw (exception);
  }
}
