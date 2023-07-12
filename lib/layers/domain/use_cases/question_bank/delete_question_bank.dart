import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../repositories/question_bank_repository.dart';

class DeleteQuestionBankUseCase implements UseCase<bool, int> {
  final QuestionBankRepository questionBankRepository;

  DeleteQuestionBankUseCase({required this.questionBankRepository});
  @override
  Future<Either<Failure, bool>> call(int questionBankId) async {
    return await questionBankRepository.deleteQuestionBank(
        questionBankId: questionBankId);
  }
}
