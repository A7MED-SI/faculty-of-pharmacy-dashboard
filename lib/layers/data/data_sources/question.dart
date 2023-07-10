import 'dart:convert';

import 'package:pharmacy_dashboard/core/constants/api/api_urls.dart';
import 'package:pharmacy_dashboard/core/unified_api/delete_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/get_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/post_api.dart';

import '../models/question/question.dart';

class QuestionDataSource {
  Future<List<Question>> getQuestions(
      {Map<String, dynamic>? queryParams}) async {
    final getApi = GetApi<List<Question>>(
      uri: ApiUris.getQuestionsUri(queryParams: queryParams),
      fromJson: (json) {
        final List<dynamic> questionsJson =
            jsonDecode(json)['data']['questions'] as List<dynamic>;

        return questionsJson
            .map<Question>((subJson) => Question.fromJson(subJson))
            .toList();
      },
      requestName: "Get All Questions",
    );
    return await getApi.callRequest();
  }

  Future<bool> deleteQuestion({required int questionId}) async {
    final deleteApi = DeleteApi<bool>(
      uri: ApiUris.deleteQuestionUri(questionId: questionId),
      fromJson: (json) {
        return jsonDecode(json)['success'];
      },
      requestName: 'Delete Question',
    );
    return await deleteApi.callRequest();
  }

  Future<Question> addQuestion({required Map<String, dynamic> body}) async {
    final postApi = PostApi<Question>(
      uri: ApiUris.addQuestionUri(),
      fromJson: (json) {
        return Question.fromJson(jsonDecode(json)['data']['question']);
      },
      requestName: 'Add Question',
      body: body,
    );
    return await postApi.callRequest();
  }

  Future<Question> updateQuestion(
      {required int questionId, required Map<String, dynamic> body}) async {
    final postApi = PostApi<Question>(
      uri: ApiUris.updateQuestionUri(questionId: questionId),
      fromJson: (json) {
        return Question.fromJson(jsonDecode(json)['data']['question']);
      },
      body: body,
      requestName: 'Update Question',
    );
    return await postApi.callRequest();
  }

  Future<Question> showQuestion(
      {Map<String, dynamic>? queryParams, required int questionId}) async {
    final getApi = GetApi<Question>(
      uri: ApiUris.showQuestionUri(questionId: questionId),
      fromJson: (json) {
        return Question.fromJson(jsonDecode(json)['data']['question']);
      },
      requestName: 'Show Question',
    );
    return await getApi.callRequest();
  }
}
