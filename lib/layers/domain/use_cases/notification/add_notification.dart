import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_case/use_case.dart';
import '../../../data/models/notification/notification.dart';
import '../../repositories/notification_repository.dart';

class AddNotificationUseCase
    implements UseCase<NotificationModel, AddNotificationParams> {
  final NotificationRepository notificationRepository;

  AddNotificationUseCase({required this.notificationRepository});
  @override
  Future<Either<Failure, NotificationModel>> call(
      AddNotificationParams params) async {
    return notificationRepository.addNotification(
      params: params.toMap(),
      image: params.image,
      imageName: params.imageName,
    );
  }
}

class AddNotificationParams {
  final String title;
  final String body;
  final Uint8List? image;
  final String? imageName;

  AddNotificationParams({
    required this.body,
    required this.title,
    this.image,
    this.imageName,
  });

  Map<String, String> toMap() {
    return {
      'title': title,
      'body': body,
    };
  }
}
