part of 'subscription_bloc.dart';

@immutable
abstract class SubscriptionEvent {}

class SubscriptionsFetched extends SubscriptionEvent {
  final GetSubscriptoinsParams params;

  SubscriptionsFetched({required this.params});
}

class SubscriptionGroupAdded extends SubscriptionEvent {
  final AddSubscriptoinGroupParams params;

  SubscriptionGroupAdded({required this.params});
}

class SubscriptionDeleted extends SubscriptionEvent {
  final int subscriptionId;

  SubscriptionDeleted({required this.subscriptionId});
}
