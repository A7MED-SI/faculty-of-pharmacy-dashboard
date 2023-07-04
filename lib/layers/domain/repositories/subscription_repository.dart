import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/layers/data/models/subscription/subscription.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, List<Subscription>>> getSubscriptions(
      {Map<String, dynamic>? params});

  Future<Either<Failure, bool>> addSubscriptionGroup(
      {Map<String, dynamic>? params});

  Future<Either<Failure, bool>> deleteSubscription(
      {required int subscriptionId});
}
