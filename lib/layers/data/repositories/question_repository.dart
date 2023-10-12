import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/core/unified_api/handling_exception.dart';
import 'package:pharmacy_dashboard/layers/data/data_sources/question.dart';
import 'package:pharmacy_dashboard/layers/data/models/question/question.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/question_repository.dart';

class QuestionRepositoryImplementation implements QuestionRepository {
  final _questionDataSource = QuestionDataSource();
  @override
  Future<Either<Failure, Question>> addQuestion({
    required Map<String, String> params,
    Uint8List? image,
    String? imageName,
  }) async {
    return await HandlingExceptionManager.wrapHandling<Question>(
        tryCall: () async {
      final response = await _questionDataSource.addQuestion(
        body: params,
        image: image,
        imageName: imageName,
      );
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, bool>> addQuestionsFromExel(
      {required int questionBankId, required Uint8List exelFile}) async {
    return await HandlingExceptionManager.wrapHandling<bool>(tryCall: () async {
      final response = await _questionDataSource.addQuestionsFromExel(
          questionBankId: questionBankId, questionsExel: exelFile);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, bool>> deleteQuestion(
      {required int questionId}) async {
    return await HandlingExceptionManager.wrapHandling<bool>(tryCall: () async {
      final response =
          await _questionDataSource.deleteQuestion(questionId: questionId);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, List<Question>>> getQuestions(
      {Map<String, dynamic>? params}) async {
    return await HandlingExceptionManager.wrapHandling<List<Question>>(
        tryCall: () async {
      final response =
          await _questionDataSource.getQuestions(queryParams: params);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, Question>> showQuestion(
      {Map<String, dynamic>? params, required int questionId}) async {
    return await HandlingExceptionManager.wrapHandling<Question>(
        tryCall: () async {
      final response = await _questionDataSource.showQuestion(
          questionId: questionId, queryParams: params);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, Question>> updateQuestion({
    required Map<String, String> params,
    required int questionId,
    Uint8List? image,
    String? imageName,
  }) async {
    return await HandlingExceptionManager.wrapHandling<Question>(
        tryCall: () async {
      final response = await _questionDataSource.updateQuestion(
        questionId: questionId,
        body: params,
        image: image,
        imageName: imageName,
      );
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, bool>> deleteQuestionList(
      {required List<int> questionIds}) async {
    return await HandlingExceptionManager.wrapHandling<bool>(tryCall: () async {
      final response = await _questionDataSource.deleteQuestionList(
          questionIds: questionIds);
      return Right(response);
    });
  }
}
