import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../repositories/subscription_repository.dart';

class MakeSubsPrintedUseCase implements UseCase<bool, List<int>> {
  final SubscriptionRepository subscriptionsRepository;

  MakeSubsPrintedUseCase({required this.subscriptionsRepository});
  @override
  Future<Either<Failure, bool>> call(List<int> printedSubs) async {
    return await subscriptionsRepository.makeAsPrinted(
        printedSubs: printedSubs);
  }
}
