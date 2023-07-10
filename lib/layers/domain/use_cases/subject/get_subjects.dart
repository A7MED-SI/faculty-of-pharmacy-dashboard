import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../repositories/subject_repository.dart';

import '../../../data/models/subject/subject.dart';

class GetSubjectsUseCase implements UseCase<List<Subject>, GetSubjectsParams> {
  final SubjectRepository subjectsRepository;

  GetSubjectsUseCase({required this.subjectsRepository});
  @override
  Future<Either<Failure, List<Subject>>> call(GetSubjectsParams params) async {
    return await subjectsRepository.getSubjects(params: params.toMap());
  }
}

class GetSubjectsParams {
  final int? isActive;
  final String? title;
  final int? yearSemesterId;
  final String? include;

  GetSubjectsParams({
    this.isActive,
    this.title,
    this.yearSemesterId,
    this.include,
  });

  Map<String, dynamic> toMap() {
    return {
      if (isActive != null) 'filter[is_active]': isActive.toString(),
      if (title != null) 'filter[title]': title,
      if (yearSemesterId != null)
        'filter[year_semester_id]': yearSemesterId.toString(),
      if (include != null) 'include': include,
    };
  }
}
