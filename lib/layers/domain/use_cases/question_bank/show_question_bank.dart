import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../data/models/question_bank/question_bank.dart';
import '../../repositories/question_bank_repository.dart';

class ShowQuestionBankUseCase implements UseCase<QuestionBank, ShowQuestionBankParams> {
  final QuestionBankRepository questionBanksRepository;

  ShowQuestionBankUseCase({required this.questionBanksRepository});
  @override
  Future<Either<Failure, QuestionBank>> call(ShowQuestionBankParams params) async {
    return questionBanksRepository.showQuestionBank(questionBankId: params.questionBankId);
  }
}

class ShowQuestionBankParams {
  final int questionBankId;

  ShowQuestionBankParams({
    required this.questionBankId,
  });

  Map<String, dynamic> toMap() {
    return {};
  }
}
