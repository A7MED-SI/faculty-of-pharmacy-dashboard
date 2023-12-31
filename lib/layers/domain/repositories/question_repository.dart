import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../data/models/question/question.dart';

abstract class QuestionRepository {
  Future<Either<Failure, List<Question>>> getQuestions(
      {Map<String, dynamic>? params});

  Future<Either<Failure, Question>> addQuestion({
    required Map<String, String> params,
    Uint8List? image,
    String? imageName,
  });

  Future<Either<Failure, Question>> showQuestion(
      {Map<String, dynamic>? params, required int questionId});

  Future<Either<Failure, Question>> updateQuestion({
    required Map<String, String> params,
    required int questionId,
    Uint8List? image,
    String? imageName,
  });

  Future<Either<Failure, bool>> deleteQuestion({required int questionId});
  
  Future<Either<Failure, bool>> deleteQuestionList({required List<int> questionIds});

  Future<Either<Failure, bool>> addQuestionsFromExel(
      {required int questionBankId, required Uint8List exelFile});
}
