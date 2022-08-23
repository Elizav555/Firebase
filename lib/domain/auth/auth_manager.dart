import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';

import 'github_sign_in.dart';

class AuthManager {
  AuthManager(this._firebaseAuth, this._gitHubSignIn, this._githubAuthProvider);

  final FirebaseAuth _firebaseAuth;
  final GitHubSignInAbstract _gitHubSignIn;
  final GithubAuthProvider _githubAuthProvider;

  Stream<User?> getUserStream() => _firebaseAuth.userChanges();

  Future<bool> _signInWeb() async {
    var res = await _firebaseAuth.signInWithPopup(_githubAuthProvider);
    return res.user != null;
  }

  Future<UserCredential?> _signInNonWeb(GitHubSignInResult result) async {
    switch (result.status) {
      case GitHubSignInResultStatus.ok:
        final credential = GithubAuthProvider.credential(result.token!);
        return await FirebaseAuth.instance.signInWithCredential(credential);

      case GitHubSignInResultStatus.cancelled:
      case GitHubSignInResultStatus.failed:
        if (kDebugMode) {
          print(result.errorMessage);
        }
        return null;
    }
  }

  Future<bool> signIn(BuildContext context) async {
    var isSuccess = false;
    if (kIsWeb) {
      isSuccess = await _signInWeb();
    } else {
      var result = await _gitHubSignIn.signIn(context);
      isSuccess = await _signInNonWeb(result) != null;
    }
    return isSuccess;
  }

  bool get isLoggedIn => _firebaseAuth.currentUser != null;
}
