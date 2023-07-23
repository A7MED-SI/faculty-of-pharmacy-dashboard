part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, error }

class AuthState {
  final AuthStatus status;

  const AuthState({
    this.status = AuthStatus.initial,
  });

  AuthState copyWith({
    AuthStatus? status,
  }) {
    return AuthState(
      status: status ?? this.status,
    );
  }
}
