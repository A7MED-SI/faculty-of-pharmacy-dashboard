import 'dart:convert';

import 'package:pharmacy_dashboard/core/constants/api/api_urls.dart';
import 'package:pharmacy_dashboard/core/unified_api/delete_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/get_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/post_api.dart';
import 'package:pharmacy_dashboard/layers/data/models/question_bank/question_bank.dart';

class QuestionBankDataSource {
  Future<List<QuestionBank>> getQuestionBanks(
      {Map<String, dynamic>? queryParams}) async {
    final getApi = GetApi<List<QuestionBank>>(
      uri: ApiUris.getQuestionBanksUri(queryParams: queryParams),
      fromJson: (json) {
        final List<dynamic> questionBanksJson =
            jsonDecode(json)['data']['questionBanks'] as List<dynamic>;

        return questionBanksJson
            .map<QuestionBank>((subJson) => QuestionBank.fromJson(subJson))
            .toList();
      },
      requestName: "Get All QuestionBanks",
    );
    return await getApi.callRequest();
  }

  Future<bool> deleteQuestionBank({required int questionBankId}) async {
    final deleteApi = DeleteApi<bool>(
      uri: ApiUris.deleteQuestionBankUri(questionBankId: questionBankId),
      fromJson: (json) {
        return jsonDecode(json)['success'];
      },
      requestName: 'Delete QuestionBank',
    );
    return await deleteApi.callRequest();
  }

  Future<QuestionBank> addQuestionBank(
      {required Map<String, dynamic> body}) async {
    final postApi = PostApi<QuestionBank>(
      uri: ApiUris.addQuestionBankUri(),
      fromJson: (json) {
        return QuestionBank.fromJson(jsonDecode(json)['data']['questionBank']);
      },
      requestName: 'Add QuestionBank',
      body: body,
    );
    return await postApi.callRequest();
  }

  Future<QuestionBank> updateQuestionBank(
      {required int questionBankId, required Map<String, dynamic> body}) async {
    final postApi = PostApi<QuestionBank>(
      uri: ApiUris.updateQuestionBankUri(questionBankId: questionBankId),
      fromJson: (json) {
        return QuestionBank.fromJson(jsonDecode(json)['data']['questionBank']);
      },
      body: body,
      requestName: 'Update QuestionBank',
    );
    return await postApi.callRequest();
  }

  Future<bool> toggleQuestionBankActive({required int questionBankId}) async {
    final postApi = PostApi<bool>(
      uri: ApiUris.toggleQuestionBankActiveUri(questionBankId: questionBankId),
      fromJson: (json) {
        return jsonDecode(json)['success'];
      },
      requestName: 'Toggle QuestionBank Activity',
    );
    return await postApi.callRequest();
  }

  Future<QuestionBank> showQuestionBank(
      {Map<String, dynamic>? queryParams, required int questionBankId}) async {
    final getApi = GetApi<QuestionBank>(
      uri: ApiUris.showQuestionBankUri(questionBankId: questionBankId),
      fromJson: (json) {
        return QuestionBank.fromJson(jsonDecode(json)['data']['questionBank']);
      },
      requestName: 'Show QuestionBank',
    );
    return await getApi.callRequest();
  }
}
