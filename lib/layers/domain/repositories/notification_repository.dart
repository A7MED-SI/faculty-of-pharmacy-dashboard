import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/layers/data/models/notification/notification.dart';

import '../../../core/error/failures.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationModel>>> getNotifications(
      {Map<String, dynamic>? params});

  Future<Either<Failure, NotificationModel>> addNotification({
    required Map<String, String> params,
    required Uint8List image,
    required String imageName,
  });

  Future<Either<Failure, NotificationModel>> showNotification(
      {Map<String, dynamic>? params, required int notificationId});

  Future<Either<Failure, bool>> deleteNotification(
      {required int notificationId});
}