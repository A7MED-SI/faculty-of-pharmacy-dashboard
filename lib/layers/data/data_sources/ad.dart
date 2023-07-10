import 'dart:convert';

import 'package:pharmacy_dashboard/core/constants/api/api_urls.dart';
import 'package:pharmacy_dashboard/core/unified_api/delete_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/get_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/post_api.dart';

import '../models/ad/ad.dart';

class AdDataSource {
  Future<List<Ad>> getAds({Map<String, dynamic>? queryParams}) async {
    final getApi = GetApi<List<Ad>>(
      uri: ApiUris.getAdsUri(queryParams: queryParams),
      fromJson: (json) {
        final List<dynamic> adsJson =
            jsonDecode(json)['data']['ads'] as List<dynamic>;

        return adsJson.map<Ad>((subJson) => Ad.fromJson(subJson)).toList();
      },
      requestName: "Get All Ads",
    );
    return await getApi.callRequest();
  }

  Future<bool> deleteAd({required int adId}) async {
    final deleteApi = DeleteApi<bool>(
      uri: ApiUris.deleteAdUri(adId: adId),
      fromJson: (json) {
        return jsonDecode(json)['success'];
      },
      requestName: 'Delete Ad',
    );
    return await deleteApi.callRequest();
  }

  Future<Ad> addAd({required Map<String, dynamic> body}) async {
    final postApi = PostApi<Ad>(
      uri: ApiUris.addAdUri(),
      fromJson: (json) {
        return Ad.fromJson(jsonDecode(json)['data']['ad']);
      },
      requestName: 'Add Ad',
      body: body,
    );
    return await postApi.callRequest();
  }

  Future<Ad> updateAd(
      {required int adId, required Map<String, dynamic> body}) async {
    final postApi = PostApi<Ad>(
      uri: ApiUris.updateAdUri(adId: adId),
      fromJson: (json) {
        return Ad.fromJson(jsonDecode(json)['data']['ad']);
      },
      body: body,
      requestName: 'Update Ad',
    );
    return await postApi.callRequest();
  }

  Future<bool> toggleAdActive({required int adId}) async {
    final postApi = PostApi<bool>(
      uri: ApiUris.toggleAdActiveUri(adId: adId),
      fromJson: (json) {
        return jsonDecode(json)['success'];
      },
      requestName: 'Toggle Ad Activity',
    );
    return await postApi.callRequest();
  }

  Future<Ad> showAd(
      {Map<String, dynamic>? queryParams, required int adId}) async {
    final getApi = GetApi<Ad>(
      uri: ApiUris.showAdUri(adId: adId),
      fromJson: (json) {
        return Ad.fromJson(jsonDecode(json)['data']['ad']);
      },
      requestName: 'Show Ad',
    );
    return await getApi.callRequest();
  }
}
