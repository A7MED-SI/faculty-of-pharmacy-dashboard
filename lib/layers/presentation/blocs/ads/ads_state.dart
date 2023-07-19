part of 'ads_bloc.dart';

enum AdsFetchingStatus { initial, loading, success, failed }

enum AddingAdStatus { initial, success, failed }

enum DeletingAdStatus { initial, success, failed }

@immutable
class AdsState {
  final AdsFetchingStatus adsFetchingStatus;
  final AddingAdStatus addingAdStatus;
  final DeletingAdStatus deletingAdStatus;
  final List<Ad> ads;

  const AdsState({
    this.adsFetchingStatus = AdsFetchingStatus.initial,
    this.addingAdStatus = AddingAdStatus.initial,
    this.deletingAdStatus = DeletingAdStatus.initial,
    this.ads = const [],
  });

  AdsState copyWith({
    AdsFetchingStatus? adsFetchingStatus,
    List<Ad>? ads,
    AddingAdStatus? addingAdStatus,
    DeletingAdStatus? deletingAdStatus,
  }) {
    return AdsState(
      ads: ads ?? this.ads,
      adsFetchingStatus: adsFetchingStatus ?? this.adsFetchingStatus,
      addingAdStatus: addingAdStatus ?? this.addingAdStatus,
      deletingAdStatus: deletingAdStatus ?? this.deletingAdStatus,
    );
  }
}
