import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';

mixin GiHubSignInMixin on GitHubSignIn {
  Future signInWithContext(BuildContext context) async {
    await signIn(context);
  }
}

abstract class GitHubSignInAbstract {
  Future signIn(BuildContext context);
}
