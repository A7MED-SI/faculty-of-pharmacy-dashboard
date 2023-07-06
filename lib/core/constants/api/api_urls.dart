// ignore_for_file: prefer_final_fields

import 'package:pharmacy_dashboard/core/constants/api/root_urls.dart';

class ApiUris {
  ApiUris._();
  static String _scheme = RootUrls.scheme;
  static String _host = RootUrls.host;
  //application initials
  static const String _authApi = 'auth/admin/';
  static const String _subscriptionApi = 'admin/subscription/';
  static const String _adminApi = 'admin/admin/';
  //Api endpoints
  static Uri _mainUri(
      {required String path, Map<String, dynamic>? queryParams}) {
    return Uri(
      host: _host,
      scheme: _scheme,
      queryParameters: queryParams,
      path: 'api/$path',
    );
  }

  //Auth
  static Uri loginUri() {
    return _mainUri(path: '${_authApi}login');
  }

  static Uri logoutUri() {
    return _mainUri(path: '${_authApi}logout');
  }

  //Subscription
  static Uri getSubscriptionsUri({Map<String, dynamic>? queryParams}) {
    return _mainUri(
      path: '${_subscriptionApi}index',
      queryParams: queryParams,
    );
  }

  static Uri addSubscriptionGroupUri() {
    return _mainUri(
      path: '${_subscriptionApi}store',
    );
  }

  static Uri deleteSubsription({required int subscriptionId}) {
    return _mainUri(path: '$_subscriptionApi$subscriptionId/destroy');
  }

  //Admins
  static Uri getAdminsUri({Map<String, dynamic>? queryParams}) {
    return _mainUri(
      path: '${_adminApi}index',
      queryParams: queryParams,
    );
  }

  static Uri addAdminUri() {
    return _mainUri(
      path: '${_adminApi}store',
    );
  }

  static Uri updateAdminUri({required int adminId}) {
    return _mainUri(
      path: '$_adminApi$adminId/update',
    );
  }

  static Uri toggleAdminActiveUri({required int adminId}) {
    return _mainUri(
      path: '$_adminApi$adminId/toggleActive',
    );
  }
}
