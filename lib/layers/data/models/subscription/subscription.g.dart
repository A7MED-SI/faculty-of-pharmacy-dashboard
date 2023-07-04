// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) => Subscription(
      id: json['id'] as int,
      subCode: json['sub_code'] as String,
      period: json['period'] as int,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      userId: json['user_id'] as int,
      subscriptionableId: json['subscriptionable_id'] as int,
      subscriptionableType: json['subscriptionable_type'] as int,
    );

Map<String, dynamic> _$SubscriptionToJson(Subscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sub_code': instance.subCode,
      'period': instance.period,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'user_id': instance.userId,
      'subscriptionable_id': instance.subscriptionableId,
      'subscriptionable_type': instance.subscriptionableType,
    };
