import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../data/models/question_bank/question_bank.dart';

abstract class QuestionBankRepository {
  Future<Either<Failure, List<QuestionBank>>> getQuestionBanks(
      {Map<String, dynamic>? params});

  Future<Either<Failure, QuestionBank>> addQuestionBank(
      {required Map<String, dynamic> params});

  Future<Either<Failure, QuestionBank>> showQuestionBank(
      {Map<String, dynamic>? params, required int questionBankId});

  Future<Either<Failure, QuestionBank>> updateQuestionBank(
      {required Map<String, dynamic> params, required int questionBankId});

  Future<Either<Failure, bool>> deleteQuestionBank(
      {required int questionBankId});

  Future<Either<Failure, bool>> toggleQuestionBankActive(
      {required int questionBankId});
}
