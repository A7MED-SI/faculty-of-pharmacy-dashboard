import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/data/models/subject_image/subject_image.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/image_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';

class GetImagesUseCase implements UseCase<List<SubjectImage>, GetImagesParams> {
  final ImageRepository imageRepository;

  GetImagesUseCase({required this.imageRepository});
  @override
  Future<Either<Failure, List<SubjectImage>>> call(GetImagesParams params) async {
    return await imageRepository.getImages(params: params.toMap());
  }
}

class GetImagesParams {
  final int subjectId;

  GetImagesParams({required this.subjectId});

  Map<String, dynamic> toMap() {
    return {
      'filter[subject_id]': subjectId.toString(),
    };
  }
}
