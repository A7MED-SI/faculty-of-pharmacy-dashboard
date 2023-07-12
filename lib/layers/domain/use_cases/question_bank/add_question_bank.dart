import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../data/models/question_bank/question_bank.dart';
import '../../repositories/question_bank_repository.dart';

class AddQuestionBankUseCase
    implements UseCase<QuestionBank, AddQuestionBankParams> {
  final QuestionBankRepository questionBanksRepository;

  AddQuestionBankUseCase({required this.questionBanksRepository});
  @override
  Future<Either<Failure, QuestionBank>> call(
      AddQuestionBankParams params) async {
    return questionBanksRepository.addQuestionBank(params: params.toMap());
  }
}

class AddQuestionBankParams {
  final String title;
  final int bankType;
  final int subjectId;
  final int? chapterOrder;
  final String? yearOfExam;
  final int? semesterOfExam;

  AddQuestionBankParams({
    required this.bankType,
    required this.title,
    required this.subjectId,
    this.chapterOrder,
    this.semesterOfExam,
    this.yearOfExam,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'bank_type': bankType.toString(),
      'subject_id': subjectId.toString(),
      if (chapterOrder != null) 'chapter_order': chapterOrder.toString(),
      if (semesterOfExam != null) 'semester_of_exam': semesterOfExam.toString(),
      if (yearOfExam != null) 'year_of_exam': yearOfExam,
    };
  }
}
