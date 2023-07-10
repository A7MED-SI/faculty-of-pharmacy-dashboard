import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';

@JsonSerializable()
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
  @JsonKey(fromJson: _roleFromJson)
  final List<int> role;

  Admin({
    required this.id,
    required this.name,
    required this.username,
    this.isActive = 1,
    required this.role,
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
}
