import 'dart:io';

import '../global_functions/global_purpose_functions.dart';
import 'handling_response.dart';
import 'printing.dart';

abstract class InitialApi<T> extends Printing with HandlingResponse {
  InitialApi({required this.uri, required String requestName, this.header})
      : super(requestName: requestName) {
    header ??= {
      HttpHeaders.authorizationHeader:
          "Bearer ${GlobalPurposeFunctions.getAccessToken()}",
      // HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      HttpHeaders.acceptHeader: "application/json"
    };
  }
  Uri uri;
  Map<String, String>? header;

  Future<T> callRequest();
}
