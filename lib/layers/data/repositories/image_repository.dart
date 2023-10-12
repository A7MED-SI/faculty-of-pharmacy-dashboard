import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/core/unified_api/handling_exception.dart';
import 'package:pharmacy_dashboard/layers/data/data_sources/image.dart';
import 'package:pharmacy_dashboard/layers/data/models/subject_image/subject_image.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/image_repository.dart';

class ImageRepositoryImplementation implements ImageRepository {
  final _imageDataSource = ImageDataSource();
  @override
  Future<Either<Failure, SubjectImage>> addImage(
      {Map<String, String>? params,
      required Uint8List image,
      required String imageName}) async {
    return await HandlingExceptionManager.wrapHandling<SubjectImage>(
        tryCall: () async {
      final response = await _imageDataSource.addImage(
        image: image,
        imageName: imageName,
        fields: params,
      );
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, bool>> deleteImage(
      {required List<int> imageIds}) async {
    return await HandlingExceptionManager.wrapHandling<bool>(
      tryCall: () async {
        final response = await _imageDataSource.deleteImage(imageIds: imageIds);
        return Right(response);
      },
    );
  }

  @override
  Future<Either<Failure, List<SubjectImage>>> getImages(
      {required Map<String, dynamic> params}) async {
    return await HandlingExceptionManager.wrapHandling<List<SubjectImage>>(
      tryCall: () async {
        final response = await _imageDataSource.getImages(queryParams: params);
        return Right(response);
      },
    );
  }

  @override
  Future<Either<Failure, SubjectImage>> updateImage(
      {Map<String, String>? params,
      required int imageId,
      Uint8List? image,
      String? imageName}) async {
    return await HandlingExceptionManager.wrapHandling<SubjectImage>(
      tryCall: () async {
        final response = await _imageDataSource.updateImage(
          imageId: imageId,
          image: image,
          imageName: imageName,
          fields: params,
        );
        return Right(response);
      },
    );
  }
}
