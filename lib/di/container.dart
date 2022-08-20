import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/repository/shopping_db.dart';
import 'package:firebase/repository/shopping_repository.dart';
import 'package:firebase/repository/storage.dart';
import 'package:firebase/state/shopping_list/shopping_list_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:github_sign_in/github_sign_in.dart';

import '../auth/auth_manager.dart';
import '../state/auth/auth_bloc.dart';
import '../ui/app.dart';
import '../ui/pages/auth_page.dart';
import '../ui/pages/list_page.dart';
import '../utils/secret.dart' as secret;

Future<void> setup() async {
  final getIt = GetIt.instance;

  //Github
  getIt.registerLazySingleton<GitHubSignIn>(() => GitHubSignIn(
      clientId: secret.GITHUB_CLIENT_ID,
      clientSecret: secret.GITHUB_CLIENT_SECRET,
      redirectUrl: secret.REDIRECT_URL));
  getIt.registerSingleton<GithubAuthProvider>(GithubAuthProvider());

  //Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  //AuthManager
  getIt.registerSingleton(AuthManager(GetIt.I.get<FirebaseAuth>(),
      GetIt.I.get<GitHubSignIn>(), GetIt.I.get<GithubAuthProvider>()));

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

  //AuthPage
  getIt.registerFactory<AuthBloc>(() => AuthBloc(GetIt.I.get<AuthManager>()));
  getIt.registerFactory<AuthPage>(
      () => AuthPage(title: 'Authorization', bloc: GetIt.I.get<AuthBloc>()));

  //App
  getIt.registerSingleton(MyApp(null, GetIt.I.get<AuthManager>(),
      GetIt.I.get<AuthPage>(), GetIt.I.get<ListPage>()));
}
