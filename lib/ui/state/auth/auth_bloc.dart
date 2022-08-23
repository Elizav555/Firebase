import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase/domain/auth/auth_repository.dart';

import 'auth_events.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository? _authRepository;

  AuthBloc() : super(LoadedState()) {
    on<SignInEvent>(signIn);
  }

  void init(AuthRepository authRepository) {
    _authRepository = _authRepository;
  }

  Future<void> signIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    await _authRepository?.signIn() == true
        ? emit(SuccessState())
        : emit(ErrorState());
  }
}
