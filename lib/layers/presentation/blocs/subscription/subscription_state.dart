part of 'subscription_bloc.dart';

enum SubsFetchingStatus { initial, loading, success, failed }

enum SubsAddingStatus { initial, success, failed }

@immutable
class SubscriptionState {
  final SubsFetchingStatus subsFetchingStatus;
  final List<Subscription> subscriptions;
  final SubsAddingStatus subsAddingStatus;

  const SubscriptionState({
    this.subsFetchingStatus = SubsFetchingStatus.initial,
    this.subsAddingStatus = SubsAddingStatus.initial,
    this.subscriptions = const [],
  });

  SubscriptionState copyWith({
    SubsFetchingStatus? subsFetchingStatus,
    List<Subscription>? subscriptions,
    SubsAddingStatus? subsAddingStatus,
  }) {
    return SubscriptionState(
      subsFetchingStatus: subsFetchingStatus ?? this.subsFetchingStatus,
      subscriptions: subscriptions ?? this.subscriptions,
      subsAddingStatus: subsAddingStatus ?? this.subsAddingStatus,
    );
  }
}
