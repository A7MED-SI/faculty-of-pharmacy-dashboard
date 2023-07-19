import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../core/error/failures.dart';
import '../../data/models/ad/ad.dart';

abstract class AdRepository {
  Future<Either<Failure, List<Ad>>> getAds({Map<String, dynamic>? params});

  Future<Either<Failure, Ad>> addAd({
    required Map<String, String> params,
    required Uint8List image,
    required String imageName,
  });

  Future<Either<Failure, Ad>> showAd(
      {Map<String, dynamic>? params, required int adId});

  Future<Either<Failure, Ad>> updateAd(
      {required Map<String, dynamic> params, required int adId});

  Future<Either<Failure, bool>> deleteAd({required int adId});

  Future<Either<Failure, bool>> toggleAdActive({required int adId});
}
