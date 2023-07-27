import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pharmacy_dashboard/core/use_case/use_case.dart';
import 'package:pharmacy_dashboard/layers/data/models/ad/ad.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/ad_repository.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/ad/add_ad.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/ad/delete_ad.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/ad/get_ads.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/ad/toggle_ad_active.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/ad/update_ad.dart';

part 'ads_event.dart';
part 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  AdsBloc() : super(const AdsState()) {
    on<AdsFetched>(_mapAdsFetched);
    on<AdAdded>(_mapAdAdded);
    on<AdDeleted>(_mapAdDeleted);
    on<AdActiveToggled>(_mapAdActiveToggled);
    on<AdUpdated>(_mapAdUpdated);
  }
  final _getAdsUseCase =
      GetAdsUseCase(adsRepository: AdRepositoryImplementation());
  final _addAdUseCase =
      AddAdUseCase(adsRepository: AdRepositoryImplementation());
  final _deleteAdUseCase =
      DeleteAdUseCase(adRepository: AdRepositoryImplementation());
  final _toggleAdActiveUseCase =
      ToggleAdActiveUseCase(adRepository: AdRepositoryImplementation());
  final _updateAdUseCase =
      UpdateAdUseCase(adsRepository: AdRepositoryImplementation());
  FutureOr<void> _mapAdsFetched(
      AdsFetched event, Emitter<AdsState> emit) async {
    emit(state.copyWith(adsFetchingStatus: AdsFetchingStatus.loading));
    final result = await _getAdsUseCase(NoParams());

    await result.fold(
      (l) async {
        emit(state.copyWith(adsFetchingStatus: AdsFetchingStatus.failed));
      },
      (ads) async {
        emit(state.copyWith(
          adsFetchingStatus: AdsFetchingStatus.success,
          ads: ads,
        ));
      },
    );
  }

  FutureOr<void> _mapAdAdded(AdAdded event, Emitter<AdsState> emit) async {
    emit(state.copyWith(adsFetchingStatus: AdsFetchingStatus.loading));

    final result = await _addAdUseCase(event.addAdParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(addingAdStatus: AddingAdStatus.failed));
      },
      (ad) async {
        emit(state.copyWith(
          addingAdStatus: AddingAdStatus.success,
          ads: List.of(state.ads)..add(ad),
        ));
      },
    );
    emit(state.copyWith(
      adsFetchingStatus: AdsFetchingStatus.success,
      addingAdStatus: AddingAdStatus.initial,
    ));
  }

  FutureOr<void> _mapAdDeleted(AdDeleted event, Emitter<AdsState> emit) async {
    emit(state.copyWith(adsFetchingStatus: AdsFetchingStatus.loading));

    final result = await _deleteAdUseCase(event.adId);

    await result.fold(
      (l) async {
        emit(state.copyWith(deletingAdStatus: DeletingAdStatus.failed));
      },
      (r) async {
        final ads = List.of(state.ads);
        ads.removeWhere((ad) => ad.id == event.adId);
        emit(state.copyWith(
          deletingAdStatus: DeletingAdStatus.success,
          ads: ads,
        ));
      },
    );
    emit(state.copyWith(
      adsFetchingStatus: AdsFetchingStatus.success,
      deletingAdStatus: DeletingAdStatus.initial,
    ));
  }

  FutureOr<void> _mapAdActiveToggled(
      AdActiveToggled event, Emitter<AdsState> emit) async {
    var adIndex = state.ads.indexWhere((ad) => ad.id == event.adId);
    var oldad = state.ads[adIndex];
    var newad = Ad(
      id: oldad.id,
      image: oldad.image,
      isActive: (oldad.isActive! + 1) % 2,
    );
    final ads = List.of(state.ads);
    ads[adIndex] = newad;
    emit(state.copyWith(ads: ads));
    final result = await _toggleAdActiveUseCase(event.adId);

    await result.fold(
      (l) async {
        ads[adIndex] = oldad;
        emit(state.copyWith(
            ads: ads, togglingAdStatus: TogglingAdStatus.failed));
        emit(state.copyWith(togglingAdStatus: TogglingAdStatus.initial));
      },
      (r) async {},
    );
  }

  FutureOr<void> _mapAdUpdated(AdUpdated event, Emitter<AdsState> emit) async {
    emit(state.copyWith(adsFetchingStatus: AdsFetchingStatus.loading));

    final result = await _updateAdUseCase(event.updateAdParams);

    await result.fold(
      (l) async {
        emit(state.copyWith(updatingAdStatus: UpdatingAdStatus.failed));
      },
      (ad) async {
        final ads = List.of(state.ads);
        final adIndex = ads
            .indexWhere((element) => element.id == event.updateAdParams.adId);
        ads[adIndex] = ad;
        emit(state.copyWith(
          updatingAdStatus: UpdatingAdStatus.success,
          ads: ads,
        ));
      },
    );
    emit(state.copyWith(
      adsFetchingStatus: AdsFetchingStatus.success,
      updatingAdStatus: UpdatingAdStatus.initial,
    ));
  }
}
