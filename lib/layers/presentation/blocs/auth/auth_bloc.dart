import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<LoginSubmitted>(_mapLoginSubmitted);
  }

  FutureOr<void> _mapLoginSubmitted(
      LoginSubmitted event, Emitter<AuthState> emit) {
    emit(state.copyWith(
      status: AuthStatus.authorized,
    ));
  }
}
