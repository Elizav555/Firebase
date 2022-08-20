import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:github_sign_in/github_sign_in.dart';

class AuthManager {
  AuthManager(this._firebaseAuth, this.gitHubSignIn, this._githubAuthProvider);

  final FirebaseAuth _firebaseAuth;
  final GitHubSignIn gitHubSignIn;
  final GithubAuthProvider _githubAuthProvider;

  Stream<User?> getUserStream() => _firebaseAuth.userChanges();

  Future<bool> signInWeb() async {
    var res = await _firebaseAuth.signInWithPopup(_githubAuthProvider);
    return res.user != null;
  }

  Future<UserCredential?> signInNonWeb(GitHubSignInResult result) async {
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

  bool get isLoggedIn => _firebaseAuth.currentUser != null;
}
