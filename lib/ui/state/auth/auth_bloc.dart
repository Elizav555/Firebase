import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../domain/auth/auth_manager.dart';
import '../../../utils/nav_const.dart';
import 'auth_events.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthManager _authManager;

  AuthBloc(this._authManager) : super(LoadedState()) {
    on<SignInEvent>(signIn);
  }

  Future<void> signIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    var isSuccess = false;
    if (kIsWeb) {
      isSuccess = await _authManager.signInWeb();
    } else {
      var result = await _authManager.gitHubSignIn.signIn(event.context);
      isSuccess = await _authManager.signInNonWeb(result) != null;
    }
    isSuccess
        ? Navigator.pushNamedAndRemoveUntil(
            event.context, Routes.shoppingList, (_) => false)
        : emit(LoadedState());
  }
}
