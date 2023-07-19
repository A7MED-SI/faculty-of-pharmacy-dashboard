import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../data/models/notification/notification.dart';
import '../../repositories/notification_repository.dart';

class GetNotificationsUseCase
    implements UseCase<List<NotificationModel>, GetNotificationsParams> {
  final NotificationRepository notificationsRepository;

  GetNotificationsUseCase({required this.notificationsRepository});
  @override
  Future<Either<Failure, List<NotificationModel>>> call(
      GetNotificationsParams params) async {
    return await notificationsRepository.getNotifications(
        params: params.toMap());
  }
}

class GetNotificationsParams {
  final int? userId;
  final int? page;
  final int? perPage;

  GetNotificationsParams({
    this.userId,
    this.page,
    this.perPage,
  });

  Map<String, dynamic> toMap() {
    return {
      if (userId != null) 'filter[user_id]': userId.toString(),
      if (page != null) 'page': page.toString(),
      if (perPage != null) 'perPage': perPage.toString(),
    };
  }
}
