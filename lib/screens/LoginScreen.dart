import 'package:flutter/material.dart';
import 'package:inkpals_app/screens/CanvasScreen.dart';
import 'package:inkpals_app/screens/MainScreen.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen_id';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Login'),
          const Text('Sign up with'),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Image.asset(('../assets/google.png')),
                    const Text(
                      'Google',
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Image.asset(('../assets/facebook.png')),
                    const Text(
                      'Facebook',
                    ),
                  ],
                ),
              ),
            ],
          ),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(context, MainScreen.id);
              },
              child: Text('Log in'))
        ],
      ),
    );
  }
}
