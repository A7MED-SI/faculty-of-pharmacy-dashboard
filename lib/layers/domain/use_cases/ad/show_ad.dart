import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../data/models/ad/ad.dart';
import '../../repositories/ad_repository.dart';

class ShowAdUseCase implements UseCase<Ad, ShowAdParams> {
  final AdRepository adsRepository;

  ShowAdUseCase({required this.adsRepository});
  @override
  Future<Either<Failure, Ad>> call(ShowAdParams params) async {
    return adsRepository.showAd(adId: params.adId);
  }
}

class ShowAdParams {
  final int adId;

  ShowAdParams({
    required this.adId,
  });

  Map<String, dynamic> toMap() {
    return {};
  }
}
