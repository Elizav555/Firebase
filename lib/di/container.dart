import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../data/shopping_db.dart';
import '../data/shopping_repository.dart';
import '../data/storage.dart';
import '../domain/auth/auth_manager.dart';
import '../domain/shopping_db.dart';
import '../domain/shopping_repository.dart';
import '../domain/shopping_storage.dart';
import '../ui/app.dart';
import '../ui/pages/auth_page.dart';
import '../ui/pages/list_page.dart';
import '../ui/state/auth/auth_bloc.dart';
import '../ui/state/shopping_list/shopping_list_bloc.dart';

Future<void> setup() async {
  final getIt = GetIt.instance;

  //Github
  getIt.registerSingleton<GithubAuthProvider>(GithubAuthProvider());
  //Google
  getIt.registerSingleton<GoogleSignIn>(GoogleSignIn());

  //Firebase
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  //AuthManager
  getIt.registerSingleton(AuthManager(GetIt.I.get<FirebaseAuth>(),
      GetIt.I.get<GithubAuthProvider>(), GetIt.I.get<GoogleSignIn>()));

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
