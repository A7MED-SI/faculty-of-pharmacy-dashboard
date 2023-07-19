import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../repositories/notification_repository.dart';

class DeleteNotificationUseCase implements UseCase<bool, int> {
  final NotificationRepository notificationRepository;

  DeleteNotificationUseCase({required this.notificationRepository});
  @override
  Future<Either<Failure, bool>> call(int notificationId) async {
    return await notificationRepository.deleteNotification(
        notificationId: notificationId);
  }
}
