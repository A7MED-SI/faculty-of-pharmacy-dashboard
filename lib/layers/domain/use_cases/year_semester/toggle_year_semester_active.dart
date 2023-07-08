import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/year_semester_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';

class ToggleYearSemesterActiveUseCase implements UseCase<bool, int> {
  final YearSemesterRepository yearSemesterRepository;

  ToggleYearSemesterActiveUseCase({required this.yearSemesterRepository});
  @override
  Future<Either<Failure, bool>> call(int yearSemesterId) async {
    return await yearSemesterRepository.toggleYearSemesterActive(yearSemesterId: yearSemesterId);
  }
}
