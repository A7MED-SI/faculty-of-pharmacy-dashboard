import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/data/models/subject_image/subject_image.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/image_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';

class UpdateImageUseCase implements UseCase<SubjectImage, UpdateImageParams> {
  final ImageRepository imageRepository;

  UpdateImageUseCase({required this.imageRepository});
  @override
  Future<Either<Failure, SubjectImage>> call(UpdateImageParams params) async {
    return imageRepository.updateImage(
      imageId: params.imageId,
      image: params.image,
      imageName: params.imageName,
      params: params.toMap(),
    );
  }
}

class UpdateImageParams {
  final int imageId;
  final Uint8List? image;
  final String? imageName;
  final String? title;

  UpdateImageParams({
    required this.imageId,
    this.image,
    this.imageName,
    this.title,
  });

  Map<String, String> toMap() {
    return {
      if (title != null) 'title': title!,
    };
  }
}
