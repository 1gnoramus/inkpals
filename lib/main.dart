import 'package:flutter/material.dart';
import 'package:inkpals_app/constants.dart';
import 'package:inkpals_app/screens/LoginScreen.dart';
import 'package:inkpals_app/screens/MainScreen.dart';
import 'package:inkpals_app/screens/RegisterScreen.dart';
import 'package:inkpals_app/screens/WelcomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: whitishColor),
        // colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFfdd25d)),
        useMaterial3: true,
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => const WelcomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegisterScreen.id: (context) => const RegisterScreen(),
        MainScreen.id: (context) => const MainScreen(),
      },
    );
  }
}
