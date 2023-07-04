import 'dart:convert';

import 'package:pharmacy_dashboard/core/constants/api/api_urls.dart';
import 'package:pharmacy_dashboard/core/unified_api/post_api.dart';
import 'package:pharmacy_dashboard/layers/data/models/login_response/login_response.dart';

class AuthDataSource {
  Future<LoginResponse> login(Map<String, String> params) async {
    final PostApi<LoginResponse> postApi = PostApi(
      uri: ApiUris.loginUri(),
      fromJson: (jsonString) {
        return LoginResponse.fromJson(jsonDecode(jsonString)['data']);
      },
      requestName: "Admin Login",
      body: params,
    );

    return await postApi.callRequest();
  }
}
