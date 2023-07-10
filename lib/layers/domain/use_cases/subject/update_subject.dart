import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/data/models/subject/subject.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/subject_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';

class UpdateSubjectUseCase implements UseCase<Subject, UpdateSubjectParams> {
  final SubjectRepository subjectsRepository;

  UpdateSubjectUseCase({required this.subjectsRepository});
  @override
  Future<Either<Failure, Subject>> call(UpdateSubjectParams params) async {
    return subjectsRepository.updateSubject(
        params: params.toMap(), subjectId: params.subjectId);
  }
}

class UpdateSubjectParams {
  final int yearSemesterId;
  final String title;
  final int subjectId;

  UpdateSubjectParams({
    required this.yearSemesterId,
    required this.title,
    required this.subjectId,
  });

  Map<String, dynamic> toMap() {
    return {
      'year_semester_id': yearSemesterId.toString(),
      'title': title,
    };
  }
}
