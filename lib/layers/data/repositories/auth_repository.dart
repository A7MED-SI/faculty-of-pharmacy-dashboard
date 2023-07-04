import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/core/unified_api/handling_exception.dart';
import 'package:pharmacy_dashboard/layers/data/data_sources/auth.dart';
import 'package:pharmacy_dashboard/layers/data/models/login_response/login_response.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/auth_repository.dart';

class AuthRepositoryImplementation implements AuthRepository {
  final _authDataSource = AuthDataSource();
  @override
  Future<Either<Failure, LoginResponse>> login(
      {required Map<String, String> params}) async {
    return await HandlingExceptionManager.wrapHandling<LoginResponse>(
      tryCall: () async {
        final response = await _authDataSource.login(params);
        return Right(response);
      },
    );
  }
}
