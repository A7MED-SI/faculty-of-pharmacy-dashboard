import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../data/models/ad/ad.dart';
import '../../repositories/ad_repository.dart';

class GetAdsUseCase implements UseCase<List<Ad>, NoParams> {
  final AdRepository adsRepository;

  GetAdsUseCase({required this.adsRepository});
  @override
  Future<Either<Failure, List<Ad>>> call(NoParams params) async {
    return await adsRepository.getAds();
  }
}
