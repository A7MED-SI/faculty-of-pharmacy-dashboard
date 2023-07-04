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
  }

  final _getSubscriptionsUseCase = GetSubscriptionsUseCase(
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
        ));
      },
    );
  }
}
