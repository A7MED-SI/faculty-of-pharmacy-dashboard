part of 'subscription_bloc.dart';

enum SubsFetchingStatus { initial, loading, success, failed }

enum SubsAddingStatus { initial, success, failed }

@immutable
class SubscriptionState {
  final SubsFetchingStatus subsFetchingStatus;
  final List<Subscription> subscriptions;
  final SubsAddingStatus subsAddingStatus;
  final List<bool> selection;
  final int totalSubscriptionsNumber;

  const SubscriptionState({
    this.subsFetchingStatus = SubsFetchingStatus.initial,
    this.subsAddingStatus = SubsAddingStatus.initial,
    this.subscriptions = const [],
    this.selection = const [],
    this.totalSubscriptionsNumber = 0,
  });

  SubscriptionState copyWith({
    SubsFetchingStatus? subsFetchingStatus,
    List<Subscription>? subscriptions,
    SubsAddingStatus? subsAddingStatus,
    List<bool>? selection,
    int? totalSubscriptionsNumber,
  }) {
    return SubscriptionState(
      subsFetchingStatus: subsFetchingStatus ?? this.subsFetchingStatus,
      subscriptions: subscriptions ?? this.subscriptions,
      subsAddingStatus: subsAddingStatus ?? this.subsAddingStatus,
      selection: selection ?? this.selection,
      totalSubscriptionsNumber: totalSubscriptionsNumber ?? this.totalSubscriptionsNumber,
    );
  }
}
