import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart%20';
import 'package:pharmacy_dashboard/core/constants/api/api_urls.dart';
import 'package:pharmacy_dashboard/core/unified_api/delete_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/get_api.dart';
import 'package:pharmacy_dashboard/core/unified_api/handling_response.dart';

import '../../../core/global_functions/global_purpose_functions.dart';
import '../../../core/unified_api/printing.dart';
import '../models/question/question.dart';

import 'package:http/http.dart' as http;

class QuestionDataSource extends Printing with HandlingResponse {
  QuestionDataSource()
      : super(requestName: 'Add Or Update Or Add Excel Question');
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
    final uri = ApiUris.addQuestionUri();
    printRequest(
      requestType: RequestType.post,
      uri: uri,
      param: body,
    );
    final http.Response response = await http
        .post(
          uri,
          headers: {
            HttpHeaders.authorizationHeader:
                "Bearer ${GlobalPurposeFunctions.getAccessToken()}",
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.acceptHeader: "application/json"
          },
          body: jsonEncode(body),
        )
        .timeout(
          const Duration(seconds: 30),
        );

    printResponse(response);

    if (response.statusCode == 200) {
      return Question.fromJson(jsonDecode(response.body)['data']['question']);
    }
    Exception exception = getException(statusCode: response.statusCode);
    throw (exception);
  }

  Future<Question> updateQuestion(
      {required int questionId, required Map<String, dynamic> body}) async {
    final uri = ApiUris.updateQuestionUri(questionId: questionId);
    printRequest(
      requestType: RequestType.post,
      uri: uri,
      param: body,
    );
    final http.Response response = await http
        .post(
          uri,
          headers: {
            HttpHeaders.authorizationHeader:
                "Bearer ${GlobalPurposeFunctions.getAccessToken()}",
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.acceptHeader: "application/json"
          },
          body: jsonEncode(body),
        )
        .timeout(
          const Duration(seconds: 30),
        );

    printResponse(response);

    if (response.statusCode == 200) {
      return Question.fromJson(jsonDecode(response.body)['data']['question']);
    }
    Exception exception = getException(statusCode: response.statusCode);
    throw (exception);
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

  Future<bool> addQuestionsFromExel(
      {required Uint8List questionsExel, required int questionBankId}) async {
    final request = http.MultipartRequest(
      'POST',
      ApiUris.addQuestionFromExelUri(questionBankId: questionBankId),
    );
    request.headers.addAll({
      HttpHeaders.authorizationHeader:
          "Bearer ${GlobalPurposeFunctions.getAccessToken()}",
      HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
      HttpHeaders.acceptHeader: "application/json"
    });
    request.files.add(MultipartFile.fromBytes('questions', questionsExel,
        filename: 'questions.xlsx'));
    // ignore: unused_local_variable
    final response = await request.send();
    final bodyString = await response.stream.bytesToString();
    print(
        'the response from add from excel is ${response.statusCode} \n the response body is $bodyString');
    if (response.statusCode == 200) {
      return true;
    }
    Exception exception = getException(statusCode: response.statusCode);
    throw (exception);
  }
}
