import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/data/models/login_response/login_response.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/admin_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';

class GetAdminsUseCase implements UseCase<List<Admin>, GetAdminsParams> {
  final AdminRepository adminRepository;

  GetAdminsUseCase({required this.adminRepository});
  @override
  Future<Either<Failure, List<Admin>>> call(GetAdminsParams params) async {
    return await adminRepository.getAdmins(params: params.toMap());
  }
}

class GetAdminsParams {
  final int? isActive;
  final int? adminRole;
  final String? username;

  GetAdminsParams({
    this.isActive,
    this.username,
    this.adminRole,
  });

  Map<String, dynamic> toMap() {
    return {
      if (isActive != null) 'filter[is_active]': isActive,
      if (username != null) 'filter[username]': username,
      if (adminRole != null) 'filter[admin_role]': adminRole,
    };
  }
}
