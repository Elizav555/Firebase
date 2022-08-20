import 'package:flutter/material.dart';

abstract class AuthEvent {}

class SignInEvent extends AuthEvent {
  final BuildContext context;

  SignInEvent(this.context);
}
