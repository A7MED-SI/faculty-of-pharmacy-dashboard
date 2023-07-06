import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/core/unified_api/handling_exception.dart';
import 'package:pharmacy_dashboard/layers/data/data_sources/admin.dart';
import 'package:pharmacy_dashboard/layers/data/models/login_response/login_response.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/admin_repository.dart';

class AdminRepositoryImplementaion implements AdminRepository {
  final _adminDataSource = AdminsDataSource();
  @override
  Future<Either<Failure, Admin>> addAdmin(
      {required Map<String, dynamic> params}) async {
    return await HandlingExceptionManager.wrapHandling<Admin>(
        tryCall: () async {
      final response = await _adminDataSource.addAdmin(body: params);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, List<Admin>>> getAdmins(
      {Map<String, dynamic>? params}) async {
    return await HandlingExceptionManager.wrapHandling<List<Admin>>(
        tryCall: () async {
      final response = await _adminDataSource.getAdmins(queryParams: params);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, bool>> toggleAdminActive(
      {required int adminId}) async {
    return await HandlingExceptionManager.wrapHandling<bool>(tryCall: () async {
      final response =
          await _adminDataSource.toggleAdminActive(adminId: adminId);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, Admin>> updateAdmin(
      {required Map<String, dynamic> params, required int adminId}) async {
    return await HandlingExceptionManager.wrapHandling<Admin>(
        tryCall: () async {
      final response =
          await _adminDataSource.updateAdmin(body: params, adminId: adminId);
      return Right(response);
    });
  }
}
