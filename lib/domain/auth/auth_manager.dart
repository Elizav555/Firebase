import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthManager {
  AuthManager(this._firebaseAuth, this._githubAuthProvider, this._googleSignIn);

  final FirebaseAuth _firebaseAuth;
  final GithubAuthProvider _githubAuthProvider;
  final GoogleSignIn _googleSignIn;

  Stream<User?> getUserStream() => _firebaseAuth.userChanges();

  Future<bool> signIn() async {
    UserCredential? credential;
    if (kIsWeb) {
      credential = await _signInWeb();
    } else {
      credential = await _signInNonWeb();
    }
    return credential != null;
  }

  Future<UserCredential?> _signInWeb() async {
    try {
      return await _firebaseAuth.signInWithPopup(_githubAuthProvider);
    } catch (error) {
      return null;
    }
  }

  Future<UserCredential?> _signInNonWeb() async {
    final account = await _googleSignIn.signIn();
    if (account != null) {
      try {
        final googleAuth = await account.authentication;
        final credential = GoogleAuthProvider.credential(
            idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
        return await _firebaseAuth.signInWithCredential(credential);
      } catch (error) {
        return null;
      }
    }
    return null;
  }

  bool get isLoggedIn => _firebaseAuth.currentUser != null;
}
