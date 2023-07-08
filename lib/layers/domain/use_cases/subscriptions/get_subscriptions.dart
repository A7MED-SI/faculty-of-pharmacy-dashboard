import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../repositories/subscription_repository.dart';

import '../../../data/models/subscription/subscription.dart';

class GetSubscriptionsUseCase
    implements UseCase<List<Subscription>, GetSubscriptoinsParams> {
  final SubscriptionRepository subscriptionsRepository;

  GetSubscriptionsUseCase({required this.subscriptionsRepository});
  @override
  Future<Either<Failure, List<Subscription>>> call(
      GetSubscriptoinsParams params) async {
    return await subscriptionsRepository.getSubscriptions(
        params: params.toMap());
  }
}

class GetSubscriptoinsParams {
  final int? isActive;
  final String? subscriptionableType;
  final int? userId;

  GetSubscriptoinsParams({
    this.isActive,
    this.subscriptionableType,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      if (isActive != null) 'filter[active]': isActive.toString(),
      if (subscriptionableType != null)
        'filter[subscriptionable_type]': subscriptionableType,
      if (userId != null) 'filter[user_id]': userId.toString(),
    };
  }
}
