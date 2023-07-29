import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/core/unified_api/handling_exception.dart';
import 'package:pharmacy_dashboard/layers/data/data_sources/subscriptions.dart';
import 'package:pharmacy_dashboard/layers/data/models/subscription/subscription.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/subscription_repository.dart';

class SubscriptionsRepositoryImplementation implements SubscriptionRepository {
  final _subscriptionsDataSource = SubscriptionsDataSource();
  @override
  Future<Either<Failure, bool>> addSubscriptionGroup(
      {required Map<String, dynamic> params}) async {
    return await HandlingExceptionManager.wrapHandling<bool>(
      tryCall: () async {
        final response =
            await _subscriptionsDataSource.addSubscriptionGroup(body: params);
        return Right(response);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteSubscription(
      {required int subscriptionId}) async {
    return await HandlingExceptionManager.wrapHandling<bool>(
      tryCall: () async {
        final response = await _subscriptionsDataSource.deleteSubscription(
            subscriptionId: subscriptionId);
        return Right(response);
      },
    );
  }

  @override
  Future<Either<Failure, SubscriptionsResponse>> getSubscriptions(
      {Map<String, dynamic>? params}) async {
    return await HandlingExceptionManager.wrapHandling<SubscriptionsResponse>(
      tryCall: () async {
        final response = await _subscriptionsDataSource.getSubscriptions(
            queryParams: params);
        return Right(response);
      },
    );
  }
}
