import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../data/models/question/question.dart';
import '../../repositories/question_repository.dart';

class GetQuestionsUseCase
    implements UseCase<List<Question>, GetQuestionsParams> {
  final QuestionRepository questionsRepository;

  GetQuestionsUseCase({required this.questionsRepository});
  @override
  Future<Either<Failure, List<Question>>> call(
      GetQuestionsParams params) async {
    return await questionsRepository.getQuestions(params: params.toMap());
  }
}

class GetQuestionsParams {
  final int? question;
  final int? questionBankId;
  GetQuestionsParams({
    this.question,
    this.questionBankId,
  });

  Map<String, dynamic> toMap() {
    return {
      if (question != null) 'filter[question]': question.toString(),
      if (questionBankId != null)
        'filter[question_bank_id]': questionBankId.toString(),
    };
  }
}
