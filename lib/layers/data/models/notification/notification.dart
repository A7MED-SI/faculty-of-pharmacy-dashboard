import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable(explicitToJson: true)
class NotificationsResponse {
  final List<NotificationModel> notifications;
  final int total;

  NotificationsResponse({
    required this.notifications,
    required this.total,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return _$NotificationsResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$NotificationsResponseToJson(this);
  }
}

@JsonSerializable()
class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String image;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.image,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return _$NotificationModelFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$NotificationModelToJson(this);
  }
}
