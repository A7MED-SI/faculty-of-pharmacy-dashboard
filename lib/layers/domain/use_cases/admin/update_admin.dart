import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/data/models/login_response/login_response.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/admin_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';

class UpdateAdminUseCase implements UseCase<Admin, UpdateAdminParams> {
  final AdminRepository adminRepository;

  UpdateAdminUseCase({required this.adminRepository});
  @override
  Future<Either<Failure, Admin>> call(UpdateAdminParams params) async {
    return await adminRepository.updateAdmin(
        params: params.toMap(), adminId: params.adminId);
  }
}

class UpdateAdminParams {
  final String name;
  final String username;
  final String password;
  final int adminId;
  final int canAddQuestionFromExcel;
  final int canAddSubscription;
  

  UpdateAdminParams({
    required this.name,
    required this.username,
    required this.password,
    required this.adminId,
    required this.canAddQuestionFromExcel,
    required this.canAddSubscription,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'username': username,
      'password': password,
      'password_confirmation': password,
      'can_add_question_from_excel': canAddQuestionFromExcel.toString(),
      'can_add_subscription': canAddSubscription.toString(),
    };
  }
}
