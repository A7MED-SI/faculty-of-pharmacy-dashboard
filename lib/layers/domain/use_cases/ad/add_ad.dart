import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../data/models/ad/ad.dart';
import '../../repositories/ad_repository.dart';

class AddAdUseCase implements UseCase<Ad, AddAdParams> {
  final AdRepository adsRepository;

  AddAdUseCase({required this.adsRepository});
  @override
  Future<Either<Failure, Ad>> call(AddAdParams params) async {
    return adsRepository.addAd(
      params: params.toMap(),
      image: params.image,
      imageName: params.imageName,
    );
  }
}

class AddAdParams {
  final String title;
  final Uint8List image;
  final String imageName;

  AddAdParams({
    required this.title,
    required this.image,
    required this.imageName,
  });

  Map<String, String> toMap() {
    return {
      'title': title,
    };
  }
}
