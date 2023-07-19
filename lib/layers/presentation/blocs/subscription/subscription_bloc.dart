import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/subscriptions_repository.dart';

import '../../../data/models/subscription/subscription.dart';
import '../../../domain/use_cases/subscriptions/add_subscription_group.dart';
import '../../../domain/use_cases/subscriptions/get_subscriptions.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(const SubscriptionState()) {
    on<SubscriptionsFetched>(_mapSubscriptionsFetched);
    on<SubscriptionGroupAdded>(_mapSubscriptionGroupAdded);
    on<AllSelectedChanged>(_mapAllSelectedChanged);
    on<RowSelectionToggled>(_mapRowSelectionToggled);
  }

  final _getSubscriptionsUseCase = GetSubscriptionsUseCase(
      subscriptionsRepository: SubscriptionsRepositoryImplementation());
  final _addSubscriptionGroupUseCase = AddSubscriptionGroupUseCase(
      subscriptionsRepository: SubscriptionsRepositoryImplementation());

  FutureOr<void> _mapSubscriptionsFetched(
      SubscriptionsFetched event, Emitter<SubscriptionState> emit) async {
    final result = await _getSubscriptionsUseCase(event.params);

    await result.fold(
      (l) async {
        emit(state.copyWith(subsFetchingStatus: SubsFetchingStatus.failed));
      },
      (subs) async {
        emit(state.copyWith(
          subsFetchingStatus: SubsFetchingStatus.success,
          subscriptions: subs,
          selection: List.filled(subs.length, false),
        ));
      },
    );
  }

  FutureOr<void> _mapSubscriptionGroupAdded(
      SubscriptionGroupAdded event, Emitter<SubscriptionState> emit) async {
    emit(state.copyWith(subsFetchingStatus: SubsFetchingStatus.loading));
    final result = await _addSubscriptionGroupUseCase(event.params);

    await result.fold(
      (l) async {
        emit(state.copyWith(
            subsFetchingStatus: SubsFetchingStatus.success,
            subsAddingStatus: SubsAddingStatus.failed));
        emit(state.copyWith(subsAddingStatus: SubsAddingStatus.initial));
      },
      (result) async {
        emit(state.copyWith(subsAddingStatus: SubsAddingStatus.success));
        emit(state.copyWith(subsAddingStatus: SubsAddingStatus.initial));
        add(SubscriptionsFetched(params: GetSubscriptoinsParams()));
      },
    );
  }

  FutureOr<void> _mapAllSelectedChanged(
      AllSelectedChanged event, Emitter<SubscriptionState> emit) {
    emit(state.copyWith(
        selection: List.filled(state.selection.length, event.value)));
  }

  FutureOr<void> _mapRowSelectionToggled(
      RowSelectionToggled event, Emitter<SubscriptionState> emit) {
    final selection = List.of(state.selection);
    selection[event.index] = !selection[event.index];
    emit(state.copyWith(selection: selection));
  }
}
