// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ad _$AdFromJson(Map<String, dynamic> json) => Ad(
      id: json['id'] as int,
      image: json['image'] as String,
      isActive: json['is_active'] as int? ?? 1,
    );

Map<String, dynamic> _$AdToJson(Ad instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
      'is_active': instance.isActive,
    };
