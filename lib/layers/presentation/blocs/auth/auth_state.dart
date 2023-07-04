part of 'auth_bloc.dart';

enum AuthStatus { authorized, unAuthorized, loading, error }

class AuthState {
  final AuthStatus status;

  const AuthState({
    this.status = AuthStatus.unAuthorized,
  });

  AuthState copyWith({
    AuthStatus? status,
  }) {
    return AuthState(
      status: status ?? this.status,
    );
  }
}
