import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pharmacy_dashboard/core/use_case/use_case.dart';
import 'package:pharmacy_dashboard/layers/data/models/ad/ad.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/ad_repository.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/ad/add_ad.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/ad/delete_ad.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/ad/get_ads.dart';

part 'ads_event.dart';
part 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  AdsBloc() : super(const AdsState()) {
    on<AdsFetched>(_mapAdsFetched);
    on<AdAdded>(_mapAdAdded);
    on<AdDeleted>(_mapAdDeleted);
  }
  final _getAdsUseCase =
      GetAdsUseCase(adsRepository: AdRepositoryImplementation());
  final _addAdUseCase =
      AddAdUseCase(adsRepository: AdRepositoryImplementation());
  final _deleteAdUseCase =
      DeleteAdUseCase(adRepository: AdRepositoryImplementation());
  FutureOr<void> _mapAdsFetched(
      AdsFetched event, Emitter<AdsState> emit) async {
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
        emit(state.copyWith(deletingAdStatus: DeletingAdStatus.success));
      },
    );
    emit(state.copyWith(
      adsFetchingStatus: AdsFetchingStatus.success,
      deletingAdStatus: DeletingAdStatus.initial,
    ));
  }
}
