// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionsResponse _$SubscriptionsResponseFromJson(
        Map<String, dynamic> json) =>
    SubscriptionsResponse(
      subscriptions: (json['subscriptions'] as List<dynamic>)
          .map((e) => Subscription.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int,
    );

Map<String, dynamic> _$SubscriptionsResponseToJson(
        SubscriptionsResponse instance) =>
    <String, dynamic>{
      'subscriptions': instance.subscriptions.map((e) => e.toJson()).toList(),
      'total': instance.total,
    };

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) => Subscription(
      id: json['id'] as int,
      subCode: json['sub_code'] as String,
      period: json['period'] as int?,
      startDate: json['start_date'] as String?,
      endDate: json['end_date'] as String?,
      userId: json['user_id'] as int?,
      subscriptionableId: json['subscriptionable_id'] as int?,
      subscriptionableType: json['subscriptionable_type'] as int,
      isActive: json['is_active'] as bool,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      isPrinted: json['is_printed'] as int,
      createdAt: Subscription._createAtFromJson(json['created_at'] as String),
    );

Map<String, dynamic> _$SubscriptionToJson(Subscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sub_code': instance.subCode,
      'period': instance.period,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'created_at': Subscription._createAtToJson(instance.createdAt),
      'user_id': instance.userId,
      'subscriptionable_id': instance.subscriptionableId,
      'subscriptionable_type': instance.subscriptionableType,
      'is_active': instance.isActive,
      'is_printed': instance.isPrinted,
      'user': instance.user,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      name: json['name'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
