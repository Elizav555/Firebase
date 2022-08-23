import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';

import '../domain/auth/github_sign_in.dart';

class GitHubSignInAbstractImpl extends GitHubSignIn
    with GiHubSignInMixin
    implements GitHubSignInAbstract {
  GitHubSignInAbstractImpl(
      {required super.clientId,
      required super.clientSecret,
      required super.redirectUrl});

  @override
  Future<GitHubSignInResult> signIn(BuildContext context) async {
    return await signInWithContext(context);
  }
}
