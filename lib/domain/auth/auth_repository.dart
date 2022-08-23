import 'package:firebase/domain/auth/auth_manager.dart';
import 'package:flutter/material.dart';

abstract class AuthRepository {
  final AuthManager authManager;
  final BuildContext context;

  AuthRepository(this.authManager, this.context);
  Future<bool> signIn();
}
