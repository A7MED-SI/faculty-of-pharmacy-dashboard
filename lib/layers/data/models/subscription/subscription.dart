import 'package:json_annotation/json_annotation.dart';
part 'subscription.g.dart';

@JsonSerializable()
class Subscription {
  final int id;
  @JsonKey(name: 'sub_code')
  final String? subCode;
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

  Subscription({
    required this.id,
    required this.subCode,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.userId,
    required this.subscriptionableId,
    required this.subscriptionableType,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return _$SubscriptionFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SubscriptionToJson(this);
  }
}
