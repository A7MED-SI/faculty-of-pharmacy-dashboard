part of 'subscription_bloc.dart';

enum SubsFetchingStatus { initial, loading, success, failed }

enum SubsAddingStatus { initial, success, failed }

enum MakeAsPrintedStatus { initial, success, failed }

@immutable
class SubscriptionState {
  final SubsFetchingStatus subsFetchingStatus;
  final List<Subscription> subscriptions;
  final SubsAddingStatus subsAddingStatus;
  final MakeAsPrintedStatus makeAsPrintedStatus;
  final List<bool> selection;
  final int totalSubscriptionsNumber;
  final String? errorMessage;
  final int subPrintingStatusIndex;

  const SubscriptionState({
    this.subsFetchingStatus = SubsFetchingStatus.initial,
    this.subsAddingStatus = SubsAddingStatus.initial,
    this.makeAsPrintedStatus = MakeAsPrintedStatus.initial,
    this.subscriptions = const [],
    this.selection = const [],
    this.totalSubscriptionsNumber = 0,
    this.errorMessage,
    this.subPrintingStatusIndex = 0,
  });

  SubscriptionState copyWith({
    SubsFetchingStatus? subsFetchingStatus,
    List<Subscription>? subscriptions,
    SubsAddingStatus? subsAddingStatus,
    List<bool>? selection,
    int? totalSubscriptionsNumber,
    String? errorMessage,
    int? subPrintingStatusIndex,
    MakeAsPrintedStatus? makeAsPrintedStatus,
  }) {
    return SubscriptionState(
      subsFetchingStatus: subsFetchingStatus ?? this.subsFetchingStatus,
      subscriptions: subscriptions ?? this.subscriptions,
      subsAddingStatus: subsAddingStatus ?? this.subsAddingStatus,
      selection: selection ?? this.selection,
      totalSubscriptionsNumber:
          totalSubscriptionsNumber ?? this.totalSubscriptionsNumber,
      errorMessage: errorMessage ?? this.errorMessage,
      subPrintingStatusIndex:
          subPrintingStatusIndex ?? this.subPrintingStatusIndex,
      makeAsPrintedStatus: makeAsPrintedStatus ?? this.makeAsPrintedStatus,
    );
  }
}
