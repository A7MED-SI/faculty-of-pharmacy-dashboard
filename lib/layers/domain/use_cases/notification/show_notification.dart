import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../data/models/notification/notification.dart';
import '../../repositories/notification_repository.dart';

class ShowNotificationUseCase
    implements UseCase<NotificationModel, ShowNotificationParams> {
  final NotificationRepository notificationsRepository;

  ShowNotificationUseCase({required this.notificationsRepository});
  @override
  Future<Either<Failure, NotificationModel>> call(
      ShowNotificationParams params) async {
    return notificationsRepository.showNotification(
        notificationId: params.notificationId);
  }
}

class ShowNotificationParams {
  final int notificationId;

  ShowNotificationParams({
    required this.notificationId,
  });

  Map<String, dynamic> toMap() {
    return {};
  }
}
