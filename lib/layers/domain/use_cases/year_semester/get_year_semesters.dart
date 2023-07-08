import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/data/models/year_semester/year_semester.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/year_semester_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';

class GetYearSemestersUseCase
    implements UseCase<List<YearSemester>, GetYearSemestersParams> {
  final YearSemesterRepository yearSemesterRepository;

  GetYearSemestersUseCase({required this.yearSemesterRepository});
  @override
  Future<Either<Failure, List<YearSemester>>> call(
      GetYearSemestersParams params) async {
    return await yearSemesterRepository.getYearSemesters(
        params: params.toMap());
  }
}

class GetYearSemestersParams {
  final int? isActive;
  String include;

  GetYearSemestersParams({
    this.isActive,
    this.include = 'subjects',
  });

  Map<String, dynamic> toMap() {
    return {
      if (isActive != null) 'filter[is_active]': isActive.toString(),
      'include': include,
    };
  }
}
