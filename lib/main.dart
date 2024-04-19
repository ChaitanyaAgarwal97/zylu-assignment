import 'package:flutter/material.dart';

import 'package:zylu_assignment/pages/home.dart';
import 'package:zylu_assignment/pages/employees.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "zylu_assignment",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      '/': (context) => Home(),
      '/employees': (context) => Employees()
    }
  ));
}
