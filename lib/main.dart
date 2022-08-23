import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../di/container.dart' as di;
import 'firebase_options.dart';
import 'ui/app.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(const MyApp());
}
