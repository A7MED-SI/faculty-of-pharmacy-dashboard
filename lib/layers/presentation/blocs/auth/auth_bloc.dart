import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pharmacy_dashboard/core/global_functions/global_purpose_functions.dart';
import 'package:pharmacy_dashboard/layers/data/repositories/auth_repository.dart';
import 'package:pharmacy_dashboard/layers/domain/use_cases/auth/login.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<LoginSubmitted>(_mapLoginSubmitted);
  }
  final _loginUseCase =
      LoginUseCase(authRepository: AuthRepositoryImplementation());
  FutureOr<void> _mapLoginSubmitted(
      LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));
    final result = await _loginUseCase(
        LoginParams(username: event.username, password: event.password));
    await result.fold(
      (l) async {
        emit(state.copyWith(status: AuthStatus.error));
      },
      (r) async {
        await GlobalPurposeFunctions.setAccesToken(r.token);
        emit(state.copyWith(status: AuthStatus.authorized));
      },
    );
  }
}
