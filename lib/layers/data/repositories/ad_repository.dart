import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/layers/data/data_sources/ad.dart';
import 'package:pharmacy_dashboard/layers/data/models/ad/ad.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/ad_repository.dart';

import '../../../core/unified_api/handling_exception.dart';

class AdRepositoryImplementation implements AdRepository {
  final _adDataSource = AdDataSource();
  @override
  Future<Either<Failure, Ad>> addAd(
      {required Map<String, String> params, required Uint8List image, required String imageName}) async {
    return await HandlingExceptionManager.wrapHandling<Ad>(
      tryCall: () async {
        final response =
            await _adDataSource.addAd(fields: params, image: image, imageName: imageName);
        return Right(response);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteAd({required int adId}) async {
    return await HandlingExceptionManager.wrapHandling<bool>(
      tryCall: () async {
        final response = await _adDataSource.deleteAd(adId: adId);
        return Right(response);
      },
    );
  }

  @override
  Future<Either<Failure, List<Ad>>> getAds(
      {Map<String, dynamic>? params}) async {
    return await HandlingExceptionManager.wrapHandling<List<Ad>>(
      tryCall: () async {
        final response = await _adDataSource.getAds(queryParams: params);
        return Right(response);
      },
    );
  }

  @override
  Future<Either<Failure, Ad>> showAd(
      {Map<String, dynamic>? params, required int adId}) async {
    return await HandlingExceptionManager.wrapHandling<Ad>(
      tryCall: () async {
        final response =
            await _adDataSource.showAd(adId: adId, queryParams: params);
        return Right(response);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> toggleAdActive({required int adId}) async {
    return await HandlingExceptionManager.wrapHandling<bool>(
      tryCall: () async {
        final response = await _adDataSource.toggleAdActive(adId: adId);
        return Right(response);
      },
    );
  }

  @override
  Future<Either<Failure, Ad>> updateAd(
      {required Map<String, dynamic> params, required int adId}) async {
    return await HandlingExceptionManager.wrapHandling<Ad>(
      tryCall: () async {
        final response = await _adDataSource.updateAd(adId: adId, body: params);
        return Right(response);
      },
    );
  }
}
