import 'dart:async';
import 'dart:convert';

import 'printing.dart';
import 'package:http/http.dart' as http;
import 'initial_api.dart';

typedef FromJson<T> = T Function(String body);

class GetApi<T> extends InitialApi<T> {
  GetApi({
    required Uri uri,
    required this.fromJson,
    required String requestName,
    this.param,
    Map<String, String>? header,
  }) : super(requestName: requestName, uri: uri, header: header);

  FromJson<T> fromJson;
  Map<String, dynamic>? param;

  @override
  Future<T> callRequest() async {
    printRequest(requestType: RequestType.get, uri: uri);
    final http.Response response = await http
        .get(
          uri,
          headers: header,
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
      errorMessage: jsonDecode(response.body)['message'],
    );
    throw (exception);
  }
}
