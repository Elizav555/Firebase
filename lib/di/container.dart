import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/domain/auth/github_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import '../data/github_sign_in.dart';
import '../data/shopping_db.dart';
import '../data/shopping_repository.dart';
import '../data/storage.dart';
import '../domain/auth/auth_manager.dart';
import '../domain/shopping_db.dart';
import '../domain/shopping_repository.dart';
import '../domain/shopping_storage.dart';
import '../ui/pages/auth_page.dart';
import '../ui/pages/list_page.dart';
import '../ui/state/auth/auth_bloc.dart';
import '../ui/state/shopping_list/shopping_list_bloc.dart';
import '../utils/secret.dart' as secret;

Future<void> init() async {
  final getIt = GetIt.instance;
  await _setUpForAuthPage(getIt);
  await _setupForShoppingList(getIt);
}

Future<void> _setUpForAuthPage(GetIt getIt) async {
  //Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  //Github
  getIt.registerSingleton<GithubAuthProvider>(GithubAuthProvider());
  getIt.registerLazySingleton<GitHubSignInAbstract>(() =>
      GitHubSignInAbstractImpl(
          clientId: secret.GITHUB_CLIENT_ID,
          clientSecret: secret.GITHUB_CLIENT_SECRET,
          redirectUrl: secret.REDIRECT_URL));

  //AuthRepository
  getIt.registerSingleton(AuthManager(GetIt.I.get<FirebaseAuth>(),
      GetIt.I.get<GitHubSignInAbstract>(), GetIt.I.get<GithubAuthProvider>()));

  //AuthPage
  getIt.registerFactory<AuthBloc>(() => AuthBloc());
  getIt.registerFactory<AuthPage>(() => AuthPage(
        title: 'Authorization',
        bloc: GetIt.I.get<AuthBloc>(),
        authManager: GetIt.I.get<AuthManager>(),
      ));
}

Future<void> _setupForShoppingList(GetIt getIt) async {
  //Firebase
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  //Repository
  getIt.registerLazySingleton<ShoppingDB>(
      () => ShoppingDBImpl(GetIt.I.get<FirebaseFirestore>()));
  getIt.registerLazySingleton<ShoppingStorage>(
      () => ShoppingStorageImpl(GetIt.I.get<FirebaseStorage>()));
  getIt.registerLazySingleton<ShoppingRepository>(() => ShoppingRepositoryImpl(
      GetIt.I.get<ShoppingDB>(), GetIt.I.get<ShoppingStorage>()));

  //ListPage
  getIt.registerFactory<ShoppingListBloc>(
      () => ShoppingListBloc(GetIt.I.get<ShoppingRepository>()));
  getIt.registerFactory<ListPage>(() => ListPage(
        bloc: GetIt.I.get<ShoppingListBloc>(),
        title: 'Shopping List',
      ));
}
