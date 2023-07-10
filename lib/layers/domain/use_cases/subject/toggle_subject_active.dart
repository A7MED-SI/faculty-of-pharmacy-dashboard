import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/subject_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';

class ToggleSubjectActiveUseCase implements UseCase<bool, int> {
  final SubjectRepository subjectRepository;

  ToggleSubjectActiveUseCase({required this.subjectRepository});
  @override
  Future<Either<Failure, bool>> call(int subjectId) async {
    return await subjectRepository.toggleSubjectActive(subjectId: subjectId);
  }
}
