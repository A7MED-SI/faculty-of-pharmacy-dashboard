import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/layers/data/data_sources/question_bank.dart';
import 'package:pharmacy_dashboard/layers/data/models/question_bank/question_bank.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/question_bank_repository.dart';

import '../../../core/unified_api/handling_exception.dart';

class QuestionBankRepositoryImplementation implements QuestionBankRepository {
  final _questionBankDataSource = QuestionBankDataSource();
  @override
  Future<Either<Failure, QuestionBank>> addQuestionBank(
      {required Map<String, dynamic> params}) async {
    return await HandlingExceptionManager.wrapHandling<QuestionBank>(
        tryCall: () async {
      final response =
          await _questionBankDataSource.addQuestionBank(body: params);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, bool>> deleteQuestionBank(
      {required int questionBankId}) async {
    return await HandlingExceptionManager.wrapHandling<bool>(tryCall: () async {
      final response = await _questionBankDataSource.deleteQuestionBank(
          questionBankId: questionBankId);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, List<QuestionBank>>> getQuestionBanks(
      {Map<String, dynamic>? params}) async {
    return await HandlingExceptionManager.wrapHandling<List<QuestionBank>>(
        tryCall: () async {
      final response =
          await _questionBankDataSource.getQuestionBanks(queryParams: params);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, QuestionBank>> showQuestionBank(
      {Map<String, dynamic>? params, required int questionBankId}) async {
    return await HandlingExceptionManager.wrapHandling<QuestionBank>(
        tryCall: () async {
      final response = await _questionBankDataSource.showQuestionBank(
          questionBankId: questionBankId, queryParams: params);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, bool>> toggleQuestionBankActive(
      {required int questionBankId}) async {
    return await HandlingExceptionManager.wrapHandling<bool>(tryCall: () async {
      final response = await _questionBankDataSource.toggleQuestionBankActive(
          questionBankId: questionBankId);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, QuestionBank>> updateQuestionBank(
      {required Map<String, dynamic> params,
      required int questionBankId}) async {
    return await HandlingExceptionManager.wrapHandling<QuestionBank>(
        tryCall: () async {
      final response = await _questionBankDataSource.updateQuestionBank(
          questionBankId: questionBankId, body: params);
      return Right(response);
    });
  }
}
