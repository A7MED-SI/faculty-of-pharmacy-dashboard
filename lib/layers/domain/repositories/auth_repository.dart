import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/layers/data/models/login_response/login_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponse>> login({required Map<String, String> params});
}
