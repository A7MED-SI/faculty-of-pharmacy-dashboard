part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;

  LoginSubmitted({
    required this.username,
    required this.password,
  });
}
