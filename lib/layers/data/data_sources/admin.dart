import 'dart:convert';

import 'package:pharmacy_dashboard/core/constants/api/api_urls.dart';
import 'package:pharmacy_dashboard/core/unified_api/get_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/post_api.dart';
import 'package:pharmacy_dashboard/layers/data/models/login_response/login_response.dart';

class AdminsDataSource {
  Future<List<Admin>> getAdmins({Map<String, dynamic>? queryParams}) async {
    final getApi = GetApi<List<Admin>>(
      uri: ApiUris.getAdminsUri(queryParams: queryParams),
      fromJson: (json) {
        final List<dynamic> adminsJson =
            jsonDecode(json)['data']['admins'] as List<dynamic>;

        return adminsJson
            .map<Admin>((subJson) => Admin.fromJson(subJson))
            .toList();
      },
      requestName: "Get All Admins",
    );
    return await getApi.callRequest();
  }

  Future<Admin> updateAdmin(
      {required int adminId, required Map<String, dynamic> body}) async {
    final postApi = PostApi<Admin>(
      uri: ApiUris.updateAdminUri(adminId: adminId),
      fromJson: (json) {
        return Admin.fromJson(jsonDecode(json)['data']['admin']);
      },
      body: body,
      requestName: 'Update Admin',
    );
    return await postApi.callRequest();
  }

  Future<Admin> addAdmin({required Map<String, dynamic> body}) async {
    final postApi = PostApi<Admin>(
      uri: ApiUris.addAdminUri(),
      fromJson: (json) {
        return Admin.fromJson(jsonDecode(json)['data']['admin']);
      },
      body: body,
      requestName: 'Add New Admin',
    );
    return await postApi.callRequest();
  }

  Future<bool> toggleAdminActive({required int adminId}) async {
    final postApi = PostApi(
      uri: ApiUris.toggleAdminActiveUri(adminId: adminId),
      fromJson: (json) {
        return jsonDecode(json)['success'];
      },
      requestName: 'Toggle Admin Activity',
    );
    return await postApi.callRequest();
  }
}
