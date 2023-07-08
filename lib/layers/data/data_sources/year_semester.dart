import 'dart:convert';

import 'package:pharmacy_dashboard/core/constants/api/api_urls.dart';
import 'package:pharmacy_dashboard/core/unified_api/get_api.dart';
import 'package:pharmacy_dashboard/layers/data/models/year_semester/year_semester.dart';

import '../../../core/unified_api/post_api.dart';

class YearSemestersDataSource {
  Future<List<YearSemester>> getYearSemesters(
      {Map<String, dynamic>? queryParams}) async {
    final getApi = GetApi<List<YearSemester>>(
      uri: ApiUris.getYearSemestersUri(queryParams: queryParams),
      fromJson: (json) {
        final List<dynamic> yearSemestersJson =
            jsonDecode(json)['data']['year_semesters'] as List<dynamic>;

        return yearSemestersJson
            .map<YearSemester>((subJson) => YearSemester.fromJson(subJson))
            .toList();
      },
      requestName: 'Get All Year Semesters',
    );

    return getApi.callRequest();
  }

  Future<bool> toggleYearSemesterActive({required int yearSemesterId}) async {
    final postApi = PostApi(
      uri: ApiUris.toggleYearSemesterUri(yearSemesterId: yearSemesterId),
      fromJson: (json) {
        return jsonDecode(json)['success'];
      },
      requestName: 'Toggle YearSemester Activity',
    );
    return await postApi.callRequest();
  }
}
