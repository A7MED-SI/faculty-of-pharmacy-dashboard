import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../repositories/subscription_repository.dart';

class DeleteSubscriptionUseCase implements UseCase<bool, int> {
  final SubscriptionRepository subscriptionsRepository;

  DeleteSubscriptionUseCase({required this.subscriptionsRepository});
  @override
  Future<Either<Failure, bool>> call(int subscriptionId) async {
    return await subscriptionsRepository.deleteSubscription(
        subscriptionId: subscriptionId);
  }
}
