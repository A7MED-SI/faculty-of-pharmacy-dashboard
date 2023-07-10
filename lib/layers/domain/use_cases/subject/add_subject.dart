import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/data/models/subject/subject.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/subject_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';

class AddSubjectUseCase implements UseCase<Subject, AddSubjectParams> {
  final SubjectRepository subjectsRepository;

  AddSubjectUseCase({required this.subjectsRepository});
  @override
  Future<Either<Failure, Subject>> call(AddSubjectParams params) async {
    return subjectsRepository.addSubject(params: params.toMap());
  }
}

class AddSubjectParams {
  final int yearSemesterId;
  final String title;

  AddSubjectParams({
    required this.yearSemesterId,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'year_semester_id': yearSemesterId.toString(),
      'title': title,
    };
  }
}
