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
    return questionRepository.addQuestion(params: params.toMap());
  }
}

class AddQuestionParams {
  final String questionText;
  final String? hint;
  final int questionBankId;
  final List<Answer> answers;

  AddQuestionParams({
    required this.questionBankId,
    required this.questionText,
    required this.answers,
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