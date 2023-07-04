import 'dart:async';

import 'printing.dart';
import 'package:http/http.dart' as http;

import 'initial_api.dart';

typedef FromJson<T> = T Function(String body);

class DeleteApi<T> extends InitialApi<T> {
  DeleteApi({
    required Uri uri,
    required this.fromJson,
    required String requestName,
    Map<String, String>? header,
  }) : super(requestName: requestName, uri: uri, header: header);

  FromJson<T> fromJson;

  @override
  Future<T> callRequest() async {
    printRequest(requestType: RequestType.delete, uri: uri);
    final http.Response response = await http
        .delete(
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
    Exception exception = getException(statusCode: response.statusCode);
    throw (exception);
  }
}
