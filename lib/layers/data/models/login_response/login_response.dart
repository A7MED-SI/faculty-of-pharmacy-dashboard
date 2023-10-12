import 'package:json_annotation/json_annotation.dart';
import 'package:pharmacy_dashboard/core/constants/api_enums/api_enums.dart';
part 'login_response.g.dart';

@JsonSerializable(explicitToJson: true)
class LoginResponse {
  final String token;
  final Admin admin;

  LoginResponse({
    required this.token,
    required this.admin,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return _$LoginResponseFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$LoginResponseToJson(this);
  }
}

@JsonSerializable()
class Admin {
  final int id;
  final String name;
  final String username;
  @JsonKey(name: 'is_active')
  final int? isActive;
  @JsonKey(fromJson: _roleFromJson, toJson: _roleToJson)
  final List<int> role;
  @JsonKey(fromJson: _permissionsFromJson, toJson: _permissionsToJson)
  final List<int> permissions;

  Admin({
    required this.id,
    required this.name,
    required this.username,
    this.isActive = 1,
    required this.role,
    required this.permissions,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return _$AdminFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$AdminToJson(this);
  }

  static List<int> _roleFromJson(List<dynamic> role) {
    return role.map<int>(
      (e) {
        return int.parse(e as String);
      },
    ).toList();
  }

  static List<String> _roleToJson(List<int> role) {
    return role.map<String>(
      (e) {
        return e.toString();
      },
    ).toList();
  }

  static List<int> _permissionsFromJson(List<dynamic> permissions) {
    return permissions.map<int>(
      (e) {
        return int.parse(e as String);
      },
    ).toList();
  }

  static List<String> _permissionsToJson(List<int> permissions) {
    return permissions.map<String>(
      (e) {
        return e.toString();
      },
    ).toList();
  }

  bool get isSuperAdmin {
    return role.contains(AdminRole.superAdmin.value);
  }

  bool get canAddQuestionFromExcel {
    return permissions.contains(AdminPermission.canAddExcel.value);
  }

  bool get canAddSubscriptions {
    return permissions.contains(AdminPermission.canAddSubs.value);
  }

  bool get canAddNotifications {
    return permissions.contains(AdminPermission.canAddNotifications.value);
  }

  bool get canAddAds {
    return permissions.contains(AdminPermission.canAddAds.value);
  }
}
