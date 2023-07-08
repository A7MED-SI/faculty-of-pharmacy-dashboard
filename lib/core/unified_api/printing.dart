import 'dart:developer';

import 'package:http/http.dart';

enum RequestType { post, get, delete, put }

class Printing {
  Printing({required this.requestName});
  String requestName;

  void printResponse(Response response) {
    log("The << status code >> into $requestName -> ${response.statusCode}");
    print("The << Response Body >> into $requestName -> \n ${response.body}");
  }

  void printRequest(
      {required RequestType requestType,
      required Uri uri,
      Map<String, dynamic>? param}) {
    log("${requestType.name} request .......");
    log("The << requestedLink >> ${uri.toString()}");
    if (param != null) log('The << Request body >> is: \n$param');
  }
}
