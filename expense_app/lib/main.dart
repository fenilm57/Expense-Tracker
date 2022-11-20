import 'dart:ui';
import 'package:expense_app/auth/google_signin.dart';
import 'package:expense_app/models/invesment.dart';
import 'package:expense_app/provider/auth.dart';
import 'package:expense_app/provider/categories_list.dart';
import 'package:expense_app/provider/expense_list.dart';
import 'package:expense_app/provider/investment_list.dart';
import 'package:expense_app/provider/savings_list.dart';
import 'package:expense_app/screens/LoginScreen.dart';
import 'package:expense_app/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widget/login.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CatagoriesList(),
        ),
        ChangeNotifierProvider(
          create: (context) => ExpenseList(),
        ),
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => SavingList(),
        ),
        ChangeNotifierProvider(
          create: (context) => InvestmentList(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData().copyWith(
          textTheme: const TextTheme(
            titleLarge: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
            bodyLarge: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Consumer<Auth>(builder: (ctx, auth, _) {
          if (auth.isAuth) {
            return HomeScreen();
          }
          return LoginScreen();
        }),
      ),
    );
  }
}
