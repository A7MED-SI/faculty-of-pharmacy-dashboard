import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/layers/data/data_sources/subject.dart';
import 'package:pharmacy_dashboard/layers/data/models/subject/subject.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/subject_repository.dart';

import '../../../core/unified_api/handling_exception.dart';

class SubjectRepositoryImplementation implements SubjectRepository {
  final _subjectDataSource = SubjectDataSource();
  @override
  Future<Either<Failure, Subject>> addSubject(
      {required Map<String, dynamic> params}) async {
    return await HandlingExceptionManager.wrapHandling<Subject>(
        tryCall: () async {
      final response = await _subjectDataSource.addSubject(body: params);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, bool>> deleteSubject({required int subjectId}) async {
    return await HandlingExceptionManager.wrapHandling<bool>(tryCall: () async {
      final response =
          await _subjectDataSource.deleteSubject(subjectId: subjectId);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, List<Subject>>> getSubjects(
      {Map<String, dynamic>? params}) async {
    return await HandlingExceptionManager.wrapHandling<List<Subject>>(
        tryCall: () async {
      final response =
          await _subjectDataSource.getSubjects(queryParams: params);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, Subject>> showSubject(
      {Map<String, dynamic>? params, required int subjectId}) async {
    return await HandlingExceptionManager.wrapHandling<Subject>(
        tryCall: () async {
      final response = await _subjectDataSource.showSubject(
          subjectId: subjectId, queryParams: params);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, bool>> toggleSubjectActive(
      {required int subjectId}) async {
    return await HandlingExceptionManager.wrapHandling<bool>(tryCall: () async {
      final response =
          await _subjectDataSource.toggleSubjectActive(subjectId: subjectId);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, Subject>> updateSubject(
      {required Map<String, dynamic> params, required int subjectId}) async {
    return await HandlingExceptionManager.wrapHandling<Subject>(
        tryCall: () async {
      final response = await _subjectDataSource.updateSubject(
          body: params, subjectId: subjectId);
      return Right(response);
    });
  }
}
