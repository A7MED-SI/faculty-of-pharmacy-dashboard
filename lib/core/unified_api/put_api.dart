import 'dart:async';
import 'dart:convert';

import 'printing.dart';
import 'package:http/http.dart' as http;
import 'initial_api.dart';

typedef FromJson<T> = T Function(String body);

class PutApi<T> extends InitialApi<T> {
  PutApi({
    required Uri uri,
    required this.param,
    required this.fromJson,
    required String requestName,
    Map<String, String>? header,
  }) : super(requestName: requestName, uri: uri, header: header);

  Map<String, dynamic> param;
  FromJson<T> fromJson;

  @override
  Future<T> callRequest() async {
    printRequest(requestType: RequestType.put, uri: uri, param: param);
    final http.Response response = await http
        .put(
          uri,
          headers: header,
          body: jsonEncode(param),
        )
        .timeout(
          const Duration(seconds: 30),
        );
    printResponse(response);
    if (response.statusCode == 200) {
      return fromJson(response.body);
    }
    Exception exception = getException(
      statusCode: response.statusCode,
    );
    throw (exception);
  }
}
