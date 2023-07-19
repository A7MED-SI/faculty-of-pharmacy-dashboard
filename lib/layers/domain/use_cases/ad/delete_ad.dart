import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../repositories/ad_repository.dart';

class DeleteAdUseCase implements UseCase<bool, int> {
  final AdRepository adRepository;

  DeleteAdUseCase({required this.adRepository});
  @override
  Future<Either<Failure, bool>> call(int adId) async {
    return await adRepository.deleteAd(adId: adId);
  }
}
