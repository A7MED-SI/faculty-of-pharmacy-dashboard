import 'dart:convert';

import 'package:pharmacy_dashboard/core/constants/api/api_urls.dart';
import 'package:pharmacy_dashboard/core/unified_api/delete_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/get_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/post_api.dart';
import 'package:pharmacy_dashboard/layers/data/models/subscription/subscription.dart';

class SubscriptionsDataSource {
  Future<List<Subscription>> getSubscriptions(
      {Map<String, dynamic>? queryParams}) async {
    final getApi = GetApi<List<Subscription>>(
      uri: ApiUris.getSubscriptionsUri(queryParams: queryParams),
      fromJson: (json) {
        final List<dynamic> subscriptionsJson =
            jsonDecode(json)['data']['subscriptions'] as List<dynamic>;

        return subscriptionsJson
            .map<Subscription>((subJson) => Subscription.fromJson(subJson))
            .toList();
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
}
