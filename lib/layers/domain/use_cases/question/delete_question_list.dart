import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../repositories/question_repository.dart';

class DeleteQuestionListUseCase implements UseCase<bool, List<int>> {
  final QuestionRepository questionRepository;

  DeleteQuestionListUseCase({required this.questionRepository});
  @override
  Future<Either<Failure, bool>> call(List<int> questionIds) async {
    return await questionRepository.deleteQuestionList(
        questionIds: questionIds);
  }
}
