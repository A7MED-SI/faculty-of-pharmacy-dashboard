part of 'image_bloc.dart';

@immutable
sealed class ImageEvent {}

class ImagesFetched extends ImageEvent {
  final GetImagesParams getImagesParams;

  ImagesFetched({required this.getImagesParams});
}

class ImageAdded extends ImageEvent {
  final AddImageParams addImageParams;

  ImageAdded({required this.addImageParams});
}

class ImageDeleted extends ImageEvent {
  final List<int> imageIds;

  ImageDeleted({required this.imageIds});
}

class ImageUpdated extends ImageEvent {
  final UpdateImageParams updateImageParams;

  ImageUpdated({required this.updateImageParams});
}
