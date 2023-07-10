import 'dart:convert';

import 'package:pharmacy_dashboard/core/constants/api/api_urls.dart';
import 'package:pharmacy_dashboard/core/unified_api/delete_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/get_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/post_api.dart';

import '../models/subject/subject.dart';


class SubjectDataSource {
  Future<List<Subject>> getSubjects({Map<String, dynamic>? queryParams}) async {
    final getApi = GetApi<List<Subject>>(
      uri: ApiUris.getSubjectsUri(queryParams: queryParams),
      fromJson: (json) {
        final List<dynamic> subjectsJson =
            jsonDecode(json)['data']['subjects'] as List<dynamic>;

        return subjectsJson
            .map<Subject>((subJson) => Subject.fromJson(subJson))
            .toList();
      },
      requestName: "Get All Subjects",
    );
    return await getApi.callRequest();
  }

  Future<bool> deleteSubject({required int subjectId}) async {
    final deleteApi = DeleteApi<bool>(
      uri: ApiUris.deleteSubjectUri(subjectId: subjectId),
      fromJson: (json) {
        return jsonDecode(json)['success'];
      },
      requestName: 'Delete Subject',
    );
    return await deleteApi.callRequest();
  }

  Future<Subject> addSubject({required Map<String, dynamic> body}) async {
    final postApi = PostApi<Subject>(
      uri: ApiUris.addSubjectUri(),
      fromJson: (json) {
        return Subject.fromJson(jsonDecode(json)['data']['subject']);
      },
      requestName: 'Add Subject',
      body: body,
    );
    return await postApi.callRequest();
  }

  Future<Subject> updateSubject(
      {required int subjectId, required Map<String, dynamic> body}) async {
    final postApi = PostApi<Subject>(
      uri: ApiUris.updateSubjectUri(subjectId: subjectId),
      fromJson: (json) {
        return Subject.fromJson(jsonDecode(json)['data']['subject']);
      },
      body: body,
      requestName: 'Update Subject',
    );
    return await postApi.callRequest();
  }

  Future<bool> toggleSubjectActive({required int subjectId}) async {
    final postApi = PostApi<bool>(
      uri: ApiUris.toggleSubjectActiveUri(subjectId: subjectId),
      fromJson: (json) {
        return jsonDecode(json)['success'];
      },
      requestName: 'Toggle Subject Activity',
    );
    return await postApi.callRequest();
  }

  Future<Subject> showSubject(
      {Map<String, dynamic>? queryParams, required int subjectId}) async {
    final getApi = GetApi<Subject>(
      uri: ApiUris.showSubjectUri(subjectId: subjectId),
      fromJson: (json) {
        return Subject.fromJson(jsonDecode(json)['data']['subject']);
      },
      requestName: 'Show Subject',
    );
    return await getApi.callRequest();
  }
}
