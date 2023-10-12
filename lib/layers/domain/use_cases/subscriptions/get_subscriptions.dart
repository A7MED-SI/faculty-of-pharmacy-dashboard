import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../repositories/subscription_repository.dart';

import '../../../data/models/subscription/subscription.dart';

class GetSubscriptionsUseCase
    implements UseCase<SubscriptionsResponse, GetSubscriptoinsParams> {
  final SubscriptionRepository subscriptionsRepository;

  GetSubscriptionsUseCase({required this.subscriptionsRepository});
  @override
  Future<Either<Failure, SubscriptionsResponse>> call(
      GetSubscriptoinsParams params) async {
    return await subscriptionsRepository.getSubscriptions(
        params: params.toMap());
  }
}

class GetSubscriptoinsParams {
  final int? isActive;
  final String? subscriptionableType;
  final int? userId;
  final int? page;
  final int? perPage;
  final int isPrinted;

  GetSubscriptoinsParams({
    this.isActive = 0,
    this.subscriptionableType,
    this.userId,
    this.page,
    this.perPage,
    required this.isPrinted,
  });

  Map<String, dynamic> toMap() {
    return {
      'filter[active]': isActive.toString(),
      'filter[is_printed]': isPrinted.toString(),
      if (subscriptionableType != null)
        'filter[subscriptionable_type]': subscriptionableType,
      if (userId != null) 'filter[user_id]': userId.toString(),
      if (page != null) 'page': page.toString(),
      if (perPage != null) 'perPage': perPage.toString(),
    };
  }
}
