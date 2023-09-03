import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/question_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../data/models/question/question.dart';

class AddQuestionUseCase implements UseCase<Question, AddQuestionParams> {
  final QuestionRepository questionRepository;

  AddQuestionUseCase({required this.questionRepository});
  @override
  Future<Either<Failure, Question>> call(AddQuestionParams params) async {
    return questionRepository.addQuestion(
      params: params.toMap(),
      image: params.image,
      imageName: params.imageName,
    );
  }
}

class AddQuestionParams {
  final String questionText;
  final String? hint;
  final int questionBankId;
  final List<Answer> answers;
  final Uint8List? image;
  final String? imageName;

  AddQuestionParams({
    required this.questionBankId,
    required this.questionText,
    required this.answers,
    this.hint,
    this.image,
    this.imageName,
  });

  Map<String, String> toMap() {
    return {
      'question_text': questionText,
      'question_bank_id': questionBankId.toString(),
      for (int i = 0; i < answers.length; i++)
        'answers[$i][answer_text]': answers[i].answerText,
      for (int i = 0; i < answers.length; i++)
        'answers[$i][is_true]': answers[i].isTrue.toString(),
      if (hint != null) 'hint': hint!,
    };
  }
}
