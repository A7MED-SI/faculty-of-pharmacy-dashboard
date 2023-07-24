import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../data/models/ad/ad.dart';
import '../../repositories/ad_repository.dart';

class UpdateAdUseCase implements UseCase<Ad, UpdateAdParams> {
  final AdRepository adsRepository;

  UpdateAdUseCase({required this.adsRepository});
  @override
  Future<Either<Failure, Ad>> call(UpdateAdParams params) async {
    return adsRepository.updateAd(
      adId: params.adId,
      image: params.image,
      imageName: params.imageName,
    );
  }
}

class UpdateAdParams {
  final int adId;
  final Uint8List image;
  final String imageName;

  UpdateAdParams({
    required this.image,
    required this.adId,
    required this.imageName,
  });

  Map<String, dynamic> toMap() {
    return {};
  }
}
