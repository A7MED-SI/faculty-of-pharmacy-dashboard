import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/data/models/subject/subject.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/subject_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';

class ShowSubjectUseCase implements UseCase<Subject, ShowSubjectParams> {
  final SubjectRepository subjectsRepository;

  ShowSubjectUseCase({required this.subjectsRepository});
  @override
  Future<Either<Failure, Subject>> call(ShowSubjectParams params) async {
    return subjectsRepository.showSubject(subjectId: params.subjectId);
  }
}

class ShowSubjectParams {
  final int subjectId;

  ShowSubjectParams({
    required this.subjectId,
  });

  Map<String, dynamic> toMap() {
    return {};
  }
}
