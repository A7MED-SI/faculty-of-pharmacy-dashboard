import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/layers/data/models/login_response/login_response.dart';

abstract class AdminRepository {
  Future<Either<Failure, List<Admin>>> getAdmins(
      {Map<String, dynamic>? params});

  Future<Either<Failure, Admin>> addAdmin(
      {required Map<String, dynamic> params});

  Future<Either<Failure, Admin>> updateAdmin(
      {required Map<String, dynamic> params, required int adminId});

  Future<Either<Failure, bool>> toggleAdminActive(
      {required int adminId});
}
