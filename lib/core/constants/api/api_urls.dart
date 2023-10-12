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
  static const String _yearSemesterApi = 'admin/yearSemester/';
  static const String _subjectApi = 'admin/subject/';
  static const String _questionBankApi = 'admin/questionBank/';
  static const String _questionApi = 'admin/question/';
  static const String _notificationApi = 'admin/notification/';
  static const String _adApi = 'admin/ad/';
  static const String _imagesApi = 'admin/tempImage/';
  static const String _dashboardApi = 'admin/dashboard/';
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

  //Dashboard
  static Uri getAllStatisticsUri({Map<String, dynamic>? queryParams}) {
    return _mainUri(
      path: '${_dashboardApi}index',
      queryParams: queryParams,
    );
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

  static Uri deleteSubscription({required int subscriptionId}) {
    return _mainUri(path: '$_subscriptionApi$subscriptionId/destroy');
  }

  static Uri makeAsPrintedUri() {
    return _mainUri(
      path: '${_subscriptionApi}makeAsPrinted',
    );
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

  static Uri deleteAdminUri({required int adminId}) {
    return _mainUri(
      path: '$_adminApi$adminId/destroy',
    );
  }

  static Uri toggleAdminActiveUri({required int adminId}) {
    return _mainUri(
      path: '$_adminApi$adminId/toggleActive',
    );
  }

  //YearSemesters
  static Uri getYearSemestersUri({Map<String, dynamic>? queryParams}) {
    return _mainUri(
      path: '${_yearSemesterApi}index',
      queryParams: queryParams,
    );
  }

  static Uri toggleYearSemesterUri({required int yearSemesterId}) {
    return _mainUri(path: '$_yearSemesterApi$yearSemesterId/toggleActive');
  }

  //Subject
  static Uri getSubjectsUri({Map<String, dynamic>? queryParams}) {
    return _mainUri(
      path: '${_subjectApi}index',
      queryParams: queryParams,
    );
  }

  static Uri showSubjectUri({required int subjectId}) {
    return _mainUri(
      path: '$_subjectApi$subjectId/show',
    );
  }

  static Uri addSubjectUri() {
    return _mainUri(
      path: '${_subjectApi}store',
    );
  }

  static Uri updateSubjectUri({required int subjectId}) {
    return _mainUri(
      path: '$_subjectApi$subjectId/update',
    );
  }

  static Uri toggleSubjectActiveUri({required int subjectId}) {
    return _mainUri(
      path: '$_subjectApi$subjectId/toggleActive',
    );
  }

  static Uri deleteSubjectUri({required int subjectId}) {
    return _mainUri(
      path: '$_subjectApi$subjectId/destroy',
    );
  }

  //QuestionBanks
  static Uri getQuestionBanksUri({Map<String, dynamic>? queryParams}) {
    return _mainUri(
      path: '${_questionBankApi}index',
      queryParams: queryParams,
    );
  }

  static Uri showQuestionBankUri({required int questionBankId}) {
    return _mainUri(
      path: '$_questionBankApi$questionBankId/show',
    );
  }

  static Uri addQuestionBankUri() {
    return _mainUri(
      path: '${_questionBankApi}store',
    );
  }

  static Uri updateQuestionBankUri({required int questionBankId}) {
    return _mainUri(
      path: '$_questionBankApi$questionBankId/update',
    );
  }

  static Uri toggleQuestionBankActiveUri({required int questionBankId}) {
    return _mainUri(
      path: '$_questionBankApi$questionBankId/toggleActive',
    );
  }

  static Uri deleteQuestionBankUri({required int questionBankId}) {
    return _mainUri(
      path: '$_questionBankApi$questionBankId/destroy',
    );
  }

  //Question
  static Uri getQuestionsUri({Map<String, dynamic>? queryParams}) {
    return _mainUri(
      path: '${_questionApi}index',
      queryParams: queryParams,
    );
  }

  static Uri showQuestionUri({required int questionId}) {
    return _mainUri(
      path: '$_questionApi$questionId/show',
    );
  }

  static Uri addQuestionUri() {
    return _mainUri(
      path: '${_questionApi}store',
    );
  }

  static Uri addQuestionFromExelUri({required int questionBankId}) {
    return _mainUri(
      path: '${_questionApi}questionBank/$questionBankId/storeFromExel',
    );
  }

  static Uri updateQuestionUri({required int questionId}) {
    return _mainUri(
      path: '$_questionApi$questionId/update',
    );
  }

  static Uri deleteQuestionUri({required int questionId}) {
    return _mainUri(
      path: '$_questionApi$questionId/destroy',
    );
  }

  static Uri deleteQuestionListUri() {
    return _mainUri(
      path: '${_questionApi}destroyList',
    );
  }

  //Notification
  static Uri getNotificationsUri({Map<String, dynamic>? queryParams}) {
    return _mainUri(
      path: '${_notificationApi}index',
      queryParams: queryParams,
    );
  }

  static Uri showNotificationUri({required int notificationId}) {
    return _mainUri(
      path: '$_notificationApi$notificationId/show',
    );
  }

  static Uri addNotificationUri() {
    return _mainUri(
      path: '${_notificationApi}store',
    );
  }

  static Uri deleteNotificationUri({required int notificationId}) {
    return _mainUri(
      path: '$_notificationApi$notificationId/destroy',
    );
  }

  //Ads
  static Uri getAdsUri({Map<String, dynamic>? queryParams}) {
    return _mainUri(
      path: '${_adApi}index',
      queryParams: queryParams,
    );
  }

  static Uri showAdUri({required int adId}) {
    return _mainUri(
      path: '$_adApi$adId/show',
    );
  }

  static Uri addAdUri() {
    return _mainUri(
      path: '${_adApi}store',
    );
  }

  static Uri updateAdUri({required int adId}) {
    return _mainUri(
      path: '$_adApi$adId/update',
    );
  }

  static Uri toggleAdActiveUri({required int adId}) {
    return _mainUri(
      path: '$_adApi$adId/toggleActive',
    );
  }

  static Uri deleteAdUri({required int adId}) {
    return _mainUri(
      path: '$_adApi$adId/destroy',
    );
  }

  //Temp Images
  static Uri getImagesUri({Map<String, dynamic>? queryParams}) {
    return _mainUri(
      path: '${_imagesApi}index',
      queryParams: queryParams,
    );
  }

  static Uri addImageUri() {
    return _mainUri(
      path: '${_imagesApi}store',
    );
  }

  static Uri updateImageUri({required int imageId}) {
    return _mainUri(
      path: '$_imagesApi$imageId/update',
    );
  }

  static Uri deleteImageListUri() {
    return _mainUri(
      path: '${_imagesApi}destroyList',
    );
  }
}
