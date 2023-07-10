import 'package:json_annotation/json_annotation.dart';
part 'subscription.g.dart';

@JsonSerializable()
class Subscription {
  final int id;
  @JsonKey(name: 'sub_code')
  final String subCode;
  final int? period;
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  @JsonKey(name: 'user_id')
  final int? userId;
  @JsonKey(name: 'subscriptionable_id')
  final int? subscriptionableId;
  @JsonKey(name: 'subscriptionable_type')
  final int subscriptionableType;
  @JsonKey(name: 'is_active')
  final bool isActive;
  final User? user;

  Subscription({
    required this.id,
    required this.subCode,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.userId,
    required this.subscriptionableId,
    required this.subscriptionableType,
    required this.isActive,
    required this.user,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return _$SubscriptionFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SubscriptionToJson(this);
  }
}

@JsonSerializable()
class User {
  final int id;
  final String name;

  User({
    required this.id,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }
}
