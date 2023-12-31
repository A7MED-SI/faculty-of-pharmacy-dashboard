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
    on<LogoutSubmitted>(_mapLogoutSubmitted);
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
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: l.message,
        ));
      },
      (r) async {
        await GlobalPurposeFunctions.setAccesToken(r.token);
        await GlobalPurposeFunctions.storeAdminModel(r.admin);
        emit(state.copyWith(status: AuthStatus.initial));
      },
    );
  }

  FutureOr<void> _mapLogoutSubmitted(
      LogoutSubmitted event, Emitter<AuthState> emit) async {
    await GlobalPurposeFunctions.removeAccesToken();
    emit(const AuthState());
  }
}
