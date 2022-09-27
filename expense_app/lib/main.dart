import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Expense App'),
          centerTitle: true,
        ),
        body: LoginButton(),
      ),
    );
  }
}
