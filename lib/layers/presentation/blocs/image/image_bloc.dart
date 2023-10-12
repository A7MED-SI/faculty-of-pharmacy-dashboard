import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/image_repository.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/images/add_image.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/images/get_image.dart';

import '../../../data/models/subject_image/subject_image.dart';
import '../../../domain/use_cases/images/delete_image.dart';
import '../../../domain/use_cases/images/update_image.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  ImageBloc() : super(const ImageState()) {
    on<ImagesFetched>(_mapImagesFetched);
    on<ImageAdded>(_mapImageAdded);
    on<ImageDeleted>(_mapImageDeleted);
    on<ImageUpdated>(_mapImageUpdated);
  }

  final _getImagesUseCase =
      GetImagesUseCase(imageRepository: ImageRepositoryImplementation());
  final _addImageUseCase =
      AddImageUseCase(imageRepository: ImageRepositoryImplementation());
  final _updateImageUseCase =
      UpdateImageUseCase(imageRepository: ImageRepositoryImplementation());
  final _deleteImageUseCase =
      DeleteImageUseCase(imageRepository: ImageRepositoryImplementation());

  FutureOr<void> _mapImagesFetched(
      ImagesFetched event, Emitter<ImageState> emit) async {
    emit(state.copyWith(imagesFetchingStatus: ImagesFetchingStatus.loading));
    final result = await _getImagesUseCase(event.getImagesParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(imagesFetchingStatus: ImagesFetchingStatus.failed));
      },
      (images) async {
        emit(state.copyWith(
          imagesFetchingStatus: ImagesFetchingStatus.success,
          images: images,
        ));
      },
    );
  }

  FutureOr<void> _mapImageAdded(
      ImageAdded event, Emitter<ImageState> emit) async {
    emit(state.copyWith(imagesFetchingStatus: ImagesFetchingStatus.loading));

    final result = await _addImageUseCase(event.addImageParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(
          addingImageStatus: AddingImageStatus.failed,
          errorMessage: l.message,
        ));
      },
      (image) async {
        emit(state.copyWith(
          addingImageStatus: AddingImageStatus.success,
          images: List.of(state.images)..add(image),
        ));
      },
    );
    emit(state.copyWith(
      imagesFetchingStatus: ImagesFetchingStatus.success,
      addingImageStatus: AddingImageStatus.initial,
    ));
  }

  FutureOr<void> _mapImageDeleted(
      ImageDeleted event, Emitter<ImageState> emit) async {
    emit(state.copyWith(imagesFetchingStatus: ImagesFetchingStatus.loading));

    final result = await _deleteImageUseCase(event.imageIds);

    await result.fold(
      (l) async {
        emit(state.copyWith(
          deletingImageStatus: DeletingImageStatus.failed,
          errorMessage: l.message,
        ));
      },
      (r) async {
        final images = List.of(state.images);
        images.removeWhere((image) => image.id == event.imageIds.first);
        emit(state.copyWith(
          deletingImageStatus: DeletingImageStatus.success,
          images: images,
        ));
      },
    );
    emit(state.copyWith(
      imagesFetchingStatus: ImagesFetchingStatus.success,
      deletingImageStatus: DeletingImageStatus.initial,
    ));
  }

  FutureOr<void> _mapImageUpdated(
      ImageUpdated event, Emitter<ImageState> emit) async {
    emit(state.copyWith(imagesFetchingStatus: ImagesFetchingStatus.loading));

    final result = await _updateImageUseCase(event.updateImageParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(
          updatingImageStatus: UpdatingImageStatus.failed,
          errorMessage: l.message,
        ));
      },
      (image) async {
        final images = List.of(state.images);
        final imageIndex = images.indexWhere(
            (element) => element.id == event.updateImageParams.imageId);
        images[imageIndex] = image;
        emit(state.copyWith(
          updatingImageStatus: UpdatingImageStatus.success,
          images: images,
        ));
      },
    );
    emit(state.copyWith(
      imagesFetchingStatus: ImagesFetchingStatus.success,
      updatingImageStatus: UpdatingImageStatus.initial,
    ));
  }
}
