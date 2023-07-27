import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/data/models/login_response/login_response.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/admin_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';

class AddAdminUseCase implements UseCase<Admin, AddAdminParams> {
  final AdminRepository adminRepository;

  AddAdminUseCase({required this.adminRepository});
  @override
  Future<Either<Failure, Admin>> call(AddAdminParams params) async {
    return await adminRepository.addAdmin(params: params.toMap());
  }
}

class AddAdminParams {
  final String name;
  final String username;
  final String password;
  final int canAddQuestionFromExcel;
  final int canAddSubscription;

  AddAdminParams({
    required this.name,
    required this.username,
    required this.password,
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
