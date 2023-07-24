import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../repositories/admin_repository.dart';

class DeleteAdminUseCase implements UseCase<bool, int> {
  final AdminRepository adminRepository;

  DeleteAdminUseCase({required this.adminRepository});
  @override
  Future<Either<Failure, bool>> call(int adminId) async {
    return await adminRepository.deleteAdmin(adminId: adminId);
  }
}
