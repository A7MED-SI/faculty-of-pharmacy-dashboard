import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../data/models/question/question.dart';
import '../../repositories/question_repository.dart';

class ShowQuestionUseCase implements UseCase<Question, ShowQuestionParams> {
  final QuestionRepository questionsRepository;

  ShowQuestionUseCase({required this.questionsRepository});
  @override
  Future<Either<Failure, Question>> call(ShowQuestionParams params) async {
    return questionsRepository.showQuestion(questionId: params.questionId);
  }
}

class ShowQuestionParams {
  final int questionId;

  ShowQuestionParams({
    required this.questionId,
  });

  Map<String, dynamic> toMap() {
    return {};
  }
}
