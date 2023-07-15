import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../data/models/question/question.dart';

abstract class QuestionRepository {
  Future<Either<Failure, List<Question>>> getQuestions(
      {Map<String, dynamic>? params});

  Future<Either<Failure, Question>> addQuestion(
      {required Map<String, dynamic> params});

  Future<Either<Failure, Question>> showQuestion(
      {Map<String, dynamic>? params, required int questionId});

  Future<Either<Failure, Question>> updateQuestion(
      {required Map<String, dynamic> params, required int questionId});

  Future<Either<Failure, bool>> deleteQuestion({required int questionId});

  Future<Either<Failure, bool>> addQuestionsFromExel(
      {required int questionBankId, required File exelFile});
}
