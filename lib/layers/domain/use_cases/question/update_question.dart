import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/question_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../data/models/question/question.dart';

class UpdateQuestionUseCase implements UseCase<Question, UpdateQuestionParams> {
  final QuestionRepository questionRepository;

  UpdateQuestionUseCase({required this.questionRepository});
  @override
  Future<Either<Failure, Question>> call(UpdateQuestionParams params) async {
    return questionRepository.updateQuestion(
        params: params.toMap(), questionId: params.questionId);
  }
}

class UpdateQuestionParams {
  final String questionText;
  final String? hint;
  final int questionBankId;
  final List<Answer> answers;
  final int questionId;

  UpdateQuestionParams({
    required this.questionBankId,
    required this.questionText,
    required this.answers,
    required this.questionId,
    this.hint,
  });

  Map<String, dynamic> toMap() {
    return {
      'question_text': questionText,
      'question_bank_id': questionBankId.toString(),
      'answers': answers.map((e) => e.toRawJson()).toList(),
      if (hint != null) 'hint': hint,
    };
  }
}
