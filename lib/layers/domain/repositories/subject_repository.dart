import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/layers/data/models/subject/subject.dart';

abstract class SubjectRepository {
  Future<Either<Failure, List<Subject>>> getSubjects(
      {Map<String, dynamic>? params});

  Future<Either<Failure, Subject>> addSubject(
      {required Map<String, dynamic> params});

  Future<Either<Failure, Subject>> showSubject(
      {Map<String, dynamic>? params, required int subjectId});

  Future<Either<Failure, Subject>> updateSubject(
      {required Map<String, dynamic> params, required int subjectId});

  Future<Either<Failure, bool>> deleteSubject({required int subjectId});

  Future<Either<Failure, bool>> toggleSubjectActive({required int subjectId});
}
