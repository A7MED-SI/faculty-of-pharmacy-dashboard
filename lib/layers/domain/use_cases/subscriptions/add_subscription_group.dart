import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../repositories/subscription_repository.dart';

class AddSubscriptionGroupUseCase
    implements UseCase<bool, AddSubscriptoinGroupParams> {
  final SubscriptionRepository subscriptionsRepository;

  AddSubscriptionGroupUseCase({required this.subscriptionsRepository});
  @override
  Future<Either<Failure, bool>> call(AddSubscriptoinGroupParams params) async {
    return await subscriptionsRepository.addSubscriptionGroup(
        params: params.toMap());
  }
}

class AddSubscriptoinGroupParams {
  final int subCount;
  final int subscriptionableType;
  final int? peroid;

  AddSubscriptoinGroupParams({
    required this.subCount,
    required this.subscriptionableType,
    this.peroid,
  });

  Map<String, dynamic> toMap() {
    return {
      'sub_count': subCount.toString(),
      'subscriptionable_type': subscriptionableType.toString(),
      if (peroid != null) 'period': peroid,
    };
  }
}
