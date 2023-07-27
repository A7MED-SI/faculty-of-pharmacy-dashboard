import 'dart:async';
import 'dart:convert';

import 'printing.dart';

import 'initial_api.dart';
import 'package:http/http.dart' as http;

typedef FromJson<T> = T Function(String body);

class PostApi<T> extends InitialApi<T> {
  PostApi({
    required Uri uri,
    this.body,
    required this.fromJson,
    required String requestName,
    Map<String, String>? header,
  }) : super(requestName: requestName, header: header, uri: uri);

  Map<String, dynamic>? body;
  FromJson<T> fromJson;
  @override
  Future<T> callRequest() async {
    printRequest(
      requestType: RequestType.post,
      uri: uri,
      param: body,
    );
    final http.Response response = await http
        .post(
          uri,
          headers: header,
          body: body,
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
