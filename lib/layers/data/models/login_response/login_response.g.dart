// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      token: json['token'] as String,
      admin: Admin.fromJson(json['admin'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'admin': instance.admin,
    };

Admin _$AdminFromJson(Map<String, dynamic> json) => Admin(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      isActive: json['is_active'] as int,
    );

Map<String, dynamic> _$AdminToJson(Admin instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'username': instance.username,
      'is_active': instance.isActive,
    };
