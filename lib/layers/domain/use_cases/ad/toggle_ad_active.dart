import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../repositories/ad_repository.dart';

class ToggleAdActiveUseCase implements UseCase<bool, int> {
  final AdRepository adRepository;

  ToggleAdActiveUseCase({required this.adRepository});
  @override
  Future<Either<Failure, bool>> call(int adId) async {
    return await adRepository.toggleAdActive(adId: adId);
  }
}
