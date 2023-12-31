import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:pharmacy_dashboard/core/constants/api/api_urls.dart';
import 'package:pharmacy_dashboard/core/unified_api/delete_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/get_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/handling_response.dart';
import 'package:pharmacy_dashboard/core/unified_api/post_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/printing.dart';

import '../../../core/global_functions/global_purpose_functions.dart';
import '../models/ad/ad.dart';

class AdDataSource extends Printing with HandlingResponse {
  AdDataSource() : super(requestName: 'Adding Ad');
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

  Future<Ad> addAd({
    Map<String, String>? fields,
    required Uint8List image,
    required String imageName,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      ApiUris.addAdUri(),
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
    if (fields != null) {
      request.fields.addAll(fields);
    }
    // ignore: unused_local_variable
    final response = await request.send();
    final bodyString = await response.stream.bytesToString();
    print(
        'the response from add Ad is ${response.statusCode} \n the response body is \n $bodyString');
    if (response.statusCode == 200) {
      return Ad.fromJson(jsonDecode(bodyString)['data']['ad']);
    }
    Exception exception = getException(
      statusCode: response.statusCode,
      errorMessage: jsonDecode(bodyString)['message'],
    );
    throw (exception);
  }

  Future<Ad> updateAd(
      {required int adId,
      required Uint8List image,
      required String imageName,
      Map<String, String>? fields}) async {
    final request = http.MultipartRequest(
      'POST',
      ApiUris.updateAdUri(adId: adId),
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
    if (fields != null) {
      request.fields.addAll(fields);
    }
    // ignore: unused_local_variable
    final response = await request.send();
    final bodyString = await response.stream.bytesToString();
    print(
        'the response from Update Ad is ${response.statusCode} \n the response body is \n $bodyString');
    if (response.statusCode == 200) {
      return Ad.fromJson(jsonDecode(bodyString)['data']['ad']);
    }
    Exception exception = getException(
      statusCode: response.statusCode,
      errorMessage: jsonDecode(bodyString)['message'],
    );
    throw (exception);
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
