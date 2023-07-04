import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/core/use_case/use_case.dart';
import 'package:pharmacy_dashboard/layers/data/models/login_response/login_response.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<LoginResponse, LoginParams> {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});
  @override
  Future<Either<Failure, LoginResponse>> call(LoginParams params) async {
    return await authRepository.login(params: params.toMap());
  }
}

class LoginParams {
  final String username;
  final String password;

  LoginParams({
    required this.username,
    required this.password,
  });

  Map<String, String> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }
}
