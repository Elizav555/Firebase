import 'package:firebase/domain/auth/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  AuthRepositoryImpl(super.authManager, super.context);

  @override
  Future<bool> signIn() {
    return authManager.signIn(context);
  }
}
