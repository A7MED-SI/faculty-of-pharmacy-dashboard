import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/question_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';

class AddQuestionFromExelUseCase
    implements UseCase<bool, AddQuestionFromExelParams> {
  final QuestionRepository questionRepository;

  AddQuestionFromExelUseCase({required this.questionRepository});
  @override
  Future<Either<Failure, bool>> call(AddQuestionFromExelParams params) async {
    return questionRepository.addQuestionsFromExel(
      questionBankId: params.questionBankId,
      exelFile: params.exelFile,
    );
  }
}

class AddQuestionFromExelParams {
  final int questionBankId;
  final File exelFile;

  AddQuestionFromExelParams({
    required this.questionBankId,
    required this.exelFile,
  });
}
