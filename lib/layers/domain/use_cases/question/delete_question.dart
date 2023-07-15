import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../repositories/question_repository.dart';

class DeleteQuestionUseCase implements UseCase<bool, int> {
  final QuestionRepository questionRepository;

  DeleteQuestionUseCase({required this.questionRepository});
  @override
  Future<Either<Failure, bool>> call(int questionId) async {
    return await questionRepository.deleteQuestion(questionId: questionId);
  }
}
