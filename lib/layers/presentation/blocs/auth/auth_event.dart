part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {}
