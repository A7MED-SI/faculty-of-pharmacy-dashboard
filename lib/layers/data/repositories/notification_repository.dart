import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:pharmacy_dashboard/core/error/failures.dart';
import 'package:pharmacy_dashboard/core/unified_api/handling_exception.dart';
import 'package:pharmacy_dashboard/layers/data/data_sources/notification.dart';
import 'package:pharmacy_dashboard/layers/data/models/notification/notification.dart';
import 'package:pharmacy_dashboard/layers/domain/repositories/notification_repository.dart';

class NotificationRepositoryImplementation implements NotificationRepository {
  final _notificationDataSource = NotificationDataSource();
  @override
  Future<Either<Failure, NotificationModel>> addNotification(
      {required Map<String, String> params,
      required Uint8List image,
      required String imageName}) async {
    return await HandlingExceptionManager.wrapHandling<NotificationModel>(
      tryCall: () async {
        final response = await _notificationDataSource.addNotification(
          fields: params,
          image: image,
          imageName: imageName,
        );
        return Right(response);
      },
    );
  }

  @override
  Future<Either<Failure, bool>> deleteNotification(
      {required int notificationId}) async {
    return await HandlingExceptionManager.wrapHandling<bool>(tryCall: () async {
      final response = await _notificationDataSource.deleteNotification(
          notificationId: notificationId);
      return Right(response);
    });
  }

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications(
      {Map<String, dynamic>? params}) async {
    return await HandlingExceptionManager.wrapHandling<List<NotificationModel>>(
      tryCall: () async {
        final response =
            await _notificationDataSource.getNotifications(queryParams: params);
        return Right(response);
      },
    );
  }

  @override
  Future<Either<Failure, NotificationModel>> showNotification(
      {Map<String, dynamic>? params, required int notificationId}) async {
    return await HandlingExceptionManager.wrapHandling<NotificationModel>(
      tryCall: () async {
        final response = await _notificationDataSource.showNotification(
            notificationId: notificationId, queryParams: params);
        return Right(response);
      },
    );
  }
}
