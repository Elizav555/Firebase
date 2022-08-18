import 'package:firebase/pages/list_page.dart';
import 'package:firebase/state/app_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppStateNotifier>(
      create: (_) => AppStateNotifier(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Firebase',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ListPage(title: 'Shopping list'),
      ),
    );
  }
}
