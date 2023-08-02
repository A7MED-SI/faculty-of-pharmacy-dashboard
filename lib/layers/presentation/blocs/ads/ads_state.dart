part of 'ads_bloc.dart';

enum AdsFetchingStatus { initial, loading, success, failed }

enum AddingAdStatus { initial, success, failed }

enum UpdatingAdStatus { initial, success, failed }

enum DeletingAdStatus { initial, success, failed }

enum TogglingAdStatus { initial, success, failed }

@immutable
class AdsState {
  final AdsFetchingStatus adsFetchingStatus;
  final AddingAdStatus addingAdStatus;
  final DeletingAdStatus deletingAdStatus;
  final TogglingAdStatus togglingAdStatus;
  final UpdatingAdStatus updatingAdStatus;
  final List<Ad> ads;
  final String? errorMessage;

  const AdsState({
    this.adsFetchingStatus = AdsFetchingStatus.initial,
    this.addingAdStatus = AddingAdStatus.initial,
    this.deletingAdStatus = DeletingAdStatus.initial,
    this.togglingAdStatus = TogglingAdStatus.initial,
    this.updatingAdStatus = UpdatingAdStatus.initial,
    this.ads = const [],
    this.errorMessage,
  });

  AdsState copyWith({
    AdsFetchingStatus? adsFetchingStatus,
    List<Ad>? ads,
    AddingAdStatus? addingAdStatus,
    DeletingAdStatus? deletingAdStatus,
    TogglingAdStatus? togglingAdStatus,
    UpdatingAdStatus? updatingAdStatus,
    String? errorMessage,
  }) {
    return AdsState(
      ads: ads ?? this.ads,
      adsFetchingStatus: adsFetchingStatus ?? this.adsFetchingStatus,
      addingAdStatus: addingAdStatus ?? this.addingAdStatus,
      deletingAdStatus: deletingAdStatus ?? this.deletingAdStatus,
      togglingAdStatus: togglingAdStatus ?? this.togglingAdStatus,
      updatingAdStatus: updatingAdStatus ?? this.updatingAdStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
