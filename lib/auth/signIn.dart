import 'package:firebase/utils/secret.dart' as secret;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';

void signIn(BuildContext context) {
  if (kIsWeb) {
    signInWeb();
  } else {
    signInNonWeb(context);
  }
}

void signInWeb() {
  final provider = GithubAuthProvider();
  FirebaseAuth.instance.signInWithPopup(provider);
}

Future<UserCredential?> signInNonWeb(BuildContext context) async {
  final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: secret.GITHUB_CLIENT_ID,
      clientSecret: secret.GITHUB_CLIENT_SECRET,
      redirectUrl: secret.REDIRECT_URL);
  var result = await gitHubSignIn.signIn(context);
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
