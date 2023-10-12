import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/image_repository.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';

class DeleteImageUseCase implements UseCase<bool, List<int>> {
  final ImageRepository imageRepository;

  DeleteImageUseCase({required this.imageRepository});
  @override
  Future<Either<Failure, bool>> call(List<int> imageIds) async {
    return await imageRepository.deleteImage(imageIds: imageIds);
  }
}
