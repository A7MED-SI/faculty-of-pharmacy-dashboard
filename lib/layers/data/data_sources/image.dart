import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:pharmacy_dashboard/core/constants/api/api_urls.dart';
import 'package:pharmacy_dashboard/core/unified_api/get_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/handling_response.dart';
import 'package:pharmacy_dashboard/core/unified_api/printing.dart';
import 'package:pharmacy_dashboard/layers/data/models/subject_image/subject_image.dart';

import '../../../core/global_functions/global_purpose_functions.dart';

class ImageDataSource extends Printing with HandlingResponse {
  ImageDataSource() : super(requestName: 'Adding Image');
  Future<List<SubjectImage>> getImages(
      {required Map<String, dynamic> queryParams}) async {
    final getApi = GetApi<List<SubjectImage>>(
      uri: ApiUris.getImagesUri(queryParams: queryParams),
      fromJson: (json) {
        final List<dynamic> adsJson =
            jsonDecode(json)['data']['temp_images'] as List<dynamic>;

        return adsJson
            .map<SubjectImage>((subJson) => SubjectImage.fromJson(subJson))
            .toList();
      },
      requestName: "Get All Images",
    );
    return await getApi.callRequest();
  }

  Future<bool> deleteImage({required List<int> imageIds}) async {
    final body = {
      'temp_image_ids': imageIds,
    };
    final request = http.Request('DELETE', ApiUris.deleteImageListUri());
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

  Future<SubjectImage> addImage({
    Map<String, String>? fields,
    required Uint8List image,
    required String imageName,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      ApiUris.addImageUri(),
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
        'the response from add SubjectImage is ${response.statusCode} \n the response body is \n $bodyString');
    if (response.statusCode == 200) {
      return SubjectImage.fromJson(
          jsonDecode(bodyString)['data']['temp_image']);
    }
    Exception exception = getException(
      statusCode: response.statusCode,
      errorMessage: jsonDecode(bodyString)['message'],
    );
    throw (exception);
  }

  Future<SubjectImage> updateImage({
    required int imageId,
    Uint8List? image,
    String? imageName,
    Map<String, String>? fields,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      ApiUris.updateImageUri(imageId: imageId),
    );
    request.headers.addAll({
      HttpHeaders.authorizationHeader:
          "Bearer ${GlobalPurposeFunctions.getAccessToken()}",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      HttpHeaders.acceptHeader: "application/json"
    });
    if (image != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'image',
        image,
        filename: imageName,
      ));
    }
    if (fields != null) {
      request.fields.addAll(fields);
    }
    // ignore: unused_local_variable
    final response = await request.send();
    final bodyString = await response.stream.bytesToString();
    print(
        'the response from Update SubjectImage is ${response.statusCode} \n the response body is \n $bodyString');
    if (response.statusCode == 200) {
      return SubjectImage.fromJson(
          jsonDecode(bodyString)['data']['temp_image']);
    }
    Exception exception = getException(
      statusCode: response.statusCode,
      errorMessage: jsonDecode(bodyString)['message'],
    );
    throw (exception);
  }
}
