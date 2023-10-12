import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/data/models/subject_image/subject_image.dart';

import '../../../core/error/failures.dart';

abstract class ImageRepository {
  Future<Either<Failure, List<SubjectImage>>> getImages(
      {required Map<String, dynamic> params});

  Future<Either<Failure, SubjectImage>> addImage({
    Map<String, String>? params,
    required Uint8List image,
    required String imageName,
  });

  Future<Either<Failure, SubjectImage>> updateImage({
    Map<String, String>? params,
    required int imageId,
    Uint8List? image,
    String? imageName,
  });

  Future<Either<Failure, bool>> deleteImage({required List<int> imageIds});
}
