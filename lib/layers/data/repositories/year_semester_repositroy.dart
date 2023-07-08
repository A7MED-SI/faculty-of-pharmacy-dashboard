import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/layers/data/data_sources/year_semester.dart';
import 'package:pharmacy_dashboard/layers/data/models/year_semester/year_semester.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/year_semester_repository.dart';

import '../../../core/unified_api/handling_exception.dart';

class YearSemesterRepositoryImplementation implements YearSemesterRepository {
  final _yearSemestersDataSource = YearSemestersDataSource();
  @override
  Future<Either<Failure, List<YearSemester>>> getYearSemesters(
      {Map<String, dynamic>? params}) async {
    return await HandlingExceptionManager.wrapHandling<List<YearSemester>>(
      tryCall: () async {
        final response = await _yearSemestersDataSource.getYearSemesters(
            queryParams: params);
        return Right(response);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> toggleYearSemesterActive(
      {required int yearSemesterId}) async {
    return await HandlingExceptionManager.wrapHandling<bool>(tryCall: () async {
      final response = await _yearSemestersDataSource.toggleYearSemesterActive(
          yearSemesterId: yearSemesterId);
      return Right(response);
    });
  }
}
