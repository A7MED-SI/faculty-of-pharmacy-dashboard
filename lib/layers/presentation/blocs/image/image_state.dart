part of 'image_bloc.dart';

enum ImagesFetchingStatus { initial, loading, success, failed }

enum AddingImageStatus { initial, success, failed }

enum UpdatingImageStatus { initial, success, failed }

enum DeletingImageStatus { initial, success, failed }

@immutable
class ImageState {
  final ImagesFetchingStatus imagesFetchingStatus;
  final AddingImageStatus addingImageStatus;
  final DeletingImageStatus deletingImageStatus;
  final UpdatingImageStatus updatingImageStatus;
  final List<SubjectImage> images;
  final String? errorMessage;

  const ImageState({
    this.imagesFetchingStatus = ImagesFetchingStatus.initial,
    this.addingImageStatus = AddingImageStatus.initial,
    this.deletingImageStatus = DeletingImageStatus.initial,
    this.updatingImageStatus = UpdatingImageStatus.initial,
    this.images = const [],
    this.errorMessage,
  });

  ImageState copyWith({
    ImagesFetchingStatus? imagesFetchingStatus,
    AddingImageStatus? addingImageStatus,
    DeletingImageStatus? deletingImageStatus,
    UpdatingImageStatus? updatingImageStatus,
    List<SubjectImage>? images,
    String? errorMessage,
  }) {
    return ImageState(
      addingImageStatus: addingImageStatus ?? this.addingImageStatus,
      deletingImageStatus: deletingImageStatus ?? this.deletingImageStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      images: images ?? this.images,
      imagesFetchingStatus: imagesFetchingStatus ?? this.imagesFetchingStatus,
      updatingImageStatus: updatingImageStatus ?? this.updatingImageStatus,
    );
  }
}
