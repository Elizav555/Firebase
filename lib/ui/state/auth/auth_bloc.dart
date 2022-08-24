import 'dart:async';

import 'package:bloc/bloc.dart';

import '../../../domain/auth/auth_manager.dart';
import 'auth_events.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthManager _authManager;

  AuthBloc(this._authManager) : super(LoadedState()) {
    on<SignInEvent>(signIn);
  }

  Future<void> signIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    await _authManager.signIn() ? emit(SuccessState()) : emit(ErrorState());
  }
}
