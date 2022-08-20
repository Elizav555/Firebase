import 'package:firebase/auth/auth_manager.dart';
import 'package:firebase/ui/pages/auth_page.dart';
import 'package:firebase/ui/pages/list_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/nav_const.dart';

class MyApp extends StatelessWidget {
  const MyApp(Key? key, this._authManager, this._authPage, this._listPage)
      : super(key: key);
  final AuthManager _authManager;
  final AuthPage _authPage;
  final ListPage _listPage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: _authManager.isLoggedIn ? Routes.shoppingList : Routes.auth,
      routes: {
        Routes.auth: (context) => _authPage,
        Routes.shoppingList: (context) => _listPage,
      },
    );
  }
}
