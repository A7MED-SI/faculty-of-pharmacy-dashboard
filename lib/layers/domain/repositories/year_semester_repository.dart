import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/layers/data/models/year_semester/year_semester.dart';

abstract class YearSemesterRepository {
  Future<Either<Failure, List<YearSemester>>> getYearSemesters(
      {Map<String, dynamic>? params});
  Future<Either<Failure, bool>> toggleYearSemesterActive(
      {required int yearSemesterId});
}
