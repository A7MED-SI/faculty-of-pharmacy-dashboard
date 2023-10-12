import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/subscriptions_repository.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/subscriptions/make_subs_printed_use_case.dart';

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
    on<SubscriptionsPrinted>(_mapSubscriptionsPrinted);
    on<PrintingStatusChanged>(_mapPrintingStatusChanged);
  }

  final _getSubscriptionsUseCase = GetSubscriptionsUseCase(
      subscriptionsRepository: SubscriptionsRepositoryImplementation());
  final _addSubscriptionGroupUseCase = AddSubscriptionGroupUseCase(
      subscriptionsRepository: SubscriptionsRepositoryImplementation());
  final _makeSubsPrintedUseCase = MakeSubsPrintedUseCase(
      subscriptionsRepository: SubscriptionsRepositoryImplementation());

  FutureOr<void> _mapSubscriptionsFetched(
      SubscriptionsFetched event, Emitter<SubscriptionState> emit) async {
    final result = await _getSubscriptionsUseCase(event.params);

    await result.fold(
      (l) async {
        emit(state.copyWith(subsFetchingStatus: SubsFetchingStatus.failed));
      },
      (response) async {
        emit(state.copyWith(
          subsFetchingStatus: SubsFetchingStatus.success,
          subscriptions: response.subscriptions,
          selection: List.filled(response.subscriptions.length, false),
          totalSubscriptionsNumber: response.total,
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
          subsAddingStatus: SubsAddingStatus.failed,
          errorMessage: l.message,
        ));
        emit(state.copyWith(subsAddingStatus: SubsAddingStatus.initial));
      },
      (result) async {
        emit(state.copyWith(subsAddingStatus: SubsAddingStatus.success));
        emit(state.copyWith(subsAddingStatus: SubsAddingStatus.initial));
        add(SubscriptionsFetched(
            params: GetSubscriptoinsParams(
                isPrinted: state.subPrintingStatusIndex)));
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

  FutureOr<void> _mapSubscriptionsPrinted(
      SubscriptionsPrinted event, Emitter<SubscriptionState> emit) async {
    final result = await _makeSubsPrintedUseCase(event.subs);

    await result.fold(
      (l) async {
        emit(state.copyWith(
          makeAsPrintedStatus: MakeAsPrintedStatus.failed,
          errorMessage: l.message,
        ));
        emit(state.copyWith(makeAsPrintedStatus: MakeAsPrintedStatus.initial));
      },
      (result) async {
        emit(state.copyWith(makeAsPrintedStatus: MakeAsPrintedStatus.success));
        emit(state.copyWith(makeAsPrintedStatus: MakeAsPrintedStatus.initial));
      },
    );
  }

  FutureOr<void> _mapPrintingStatusChanged(
      PrintingStatusChanged event, Emitter<SubscriptionState> emit) {
    emit(state.copyWith(subPrintingStatusIndex: event.newValue));
  }
}
