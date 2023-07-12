import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/data/models/question_bank/question_bank.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../repositories/question_bank_repository.dart';

class GetQuestionBanksUseCase
    implements UseCase<List<QuestionBank>, GetQuestionBanksParams> {
  final QuestionBankRepository questionBanksRepository;

  GetQuestionBanksUseCase({required this.questionBanksRepository});
  @override
  Future<Either<Failure, List<QuestionBank>>> call(
      GetQuestionBanksParams params) async {
    return await questionBanksRepository.getQuestionBanks(
        params: params.toMap());
  }
}

class GetQuestionBanksParams {
  final int? bankType;
  final int? chapterOrder;
  final int? yearOfExam;
  final int? semesterOfExam;
  final int? isActive;
  final int? subjectId;
  final String? include;
  GetQuestionBanksParams({
    this.bankType,
    this.yearOfExam,
    this.chapterOrder,
    this.semesterOfExam,
    this.include,
    this.isActive,
    this.subjectId,
  });

  Map<String, dynamic> toMap() {
    return {
      if (bankType != null) 'filter[bank_type]': bankType.toString(),
      if (chapterOrder != null)
        'filter[chapter_order]': chapterOrder.toString(),
      if (yearOfExam != null) 'filter[year_of_exam]': yearOfExam,
      if (semesterOfExam != null) 'filter[semester_of_exam]': semesterOfExam,
      if (isActive != null) 'filter[is_active]': isActive,
      if (subjectId != null) 'filter[subject_id]': subjectId,
      if (include != null) 'include': include,
    };
  }
}
