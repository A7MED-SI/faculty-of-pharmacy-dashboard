import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/data/models/subject_image/subject_image.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/image_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';

class AddImageUseCase implements UseCase<SubjectImage, AddImageParams> {
  final ImageRepository imageRepository;

  AddImageUseCase({required this.imageRepository});
  @override
  Future<Either<Failure, SubjectImage>> call(AddImageParams params) async {
    return imageRepository.addImage(
      params: params.toMap(),
      image: params.image,
      imageName: params.imageName,
    );
  }
}

class AddImageParams {
  final Uint8List image;
  final String imageName;
  final String? title;
  final int subjectId;

  AddImageParams({
    required this.image,
    required this.imageName,
    required this.subjectId,
    this.title,
  });

  Map<String, String> toMap() {
    return {
      if (title != null) 'title': title!,
      'subject_id': subjectId.toString(),
    };
  }
}
