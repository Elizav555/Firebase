import 'package:firebase/repository/shopping_db.dart';
import 'package:firebase/repository/shopping_repository.dart';
import 'package:firebase/repository/storage.dart';
import 'package:firebase/state/shopping_list_bloc.dart';
import 'package:get_it/get_it.dart';

import '../ui/pages/list_page.dart';

Future<void> setup() async {
  final getIt = GetIt.instance;

  getIt.registerLazySingleton<ShoppingDB>(() => ShoppingDBImpl());
  getIt.registerLazySingleton<ShoppingStorage>(() => ShoppingStorageImpl());
  getIt.registerLazySingleton<ShoppingRepository>(() => ShoppingRepositoryImpl(
      GetIt.I.get<ShoppingDB>(), GetIt.I.get<ShoppingStorage>()));

  getIt.registerFactory<ShoppingListBloc>(
      () => ShoppingListBloc(GetIt.I.get<ShoppingRepository>()));
  getIt.registerFactory<ListPage>(() => ListPage(
        bloc: GetIt.I.get<ShoppingListBloc>(),
        title: 'shopping List',
      ));
}
