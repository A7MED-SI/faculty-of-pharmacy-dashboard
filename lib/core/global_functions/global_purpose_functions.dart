import 'dart:convert';

import 'package:pharmacy_dashboard/layers/data/models/login_response/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/preferences/shared_preferences_keys.dart';
import '../injection.dart';

class GlobalPurposeFunctions {
  GlobalPurposeFunctions._();

  static String? getAccessToken() {
    final prefs = serviceLocator<SharedPreferences>();
    return prefs.getString(SharedPreferanceKeys.accessToken);
  }

  static Future<bool> removeAccesToken() async {
    final prefs = serviceLocator<SharedPreferences>();
    return await prefs.remove(SharedPreferanceKeys.accessToken);
  }

  static Future<bool> setAccesToken(String token) async {
    final prefs = serviceLocator<SharedPreferences>();
    return await prefs.setString(SharedPreferanceKeys.accessToken, token);
  }

  static Future<bool> storeAdminModel(Admin admin) async {
    final prefs = serviceLocator<SharedPreferences>();
    return await prefs.setString(
        SharedPreferanceKeys.admin, jsonEncode(admin.toJson()));
  }

  static Admin? getAdminModel() {
    final prefs = serviceLocator<SharedPreferences>();
    var adminJson = prefs.getString(SharedPreferanceKeys.admin);
    if (adminJson == null) {
      return null;
    }
    return Admin.fromJson(jsonDecode(adminJson));
  }
}
