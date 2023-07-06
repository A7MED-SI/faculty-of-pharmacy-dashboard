import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/admin_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';

class ToggleAdminActiveUseCase implements UseCase<bool, int> {
  final AdminRepository adminRepository;

  ToggleAdminActiveUseCase({required this.adminRepository});
  @override
  Future<Either<Failure, bool>> call(int adminId) async {
    return await adminRepository.toggleAdminActive(adminId: adminId);
  }
}
