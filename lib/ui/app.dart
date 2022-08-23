import 'package:firebase/ui/pages/auth_page.dart';
import 'package:firebase/ui/pages/list_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../domain/auth/auth_manager.dart';
import '../utils/nav_const.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: GetIt.I.get<AuthManager>().isLoggedIn
          ? Routes.shoppingList
          : Routes.auth,
      routes: {
        Routes.auth: (context) => GetIt.I.get<AuthPage>(),
        Routes.shoppingList: (context) => GetIt.I.get<ListPage>(),
      },
    );
  }
}
