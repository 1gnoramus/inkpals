import 'package:flutter/material.dart';
import 'package:inkpals_app/components/description_text.dart';
import 'package:inkpals_app/components/header_text.dart';
import 'package:inkpals_app/components/red_nav_button.dart';
import 'package:inkpals_app/screens/RegisterScreen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen_id';
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                './lib/assets/canvas.png',
                scale: 0.3,
              ),
              SizedBox(
                height: 40.0,
              ),
              HeaderText(text: 'InkPals'),
              DescriptionText(text: 'Draw Together, Connect Forever.'),
              SizedBox(
                height: 40.0,
              ),
              RedNavigationButton(
                  text: 'Create an account', widgetId: RegisterScreen.id)
            ],
          ),
        ),
      ),
    );
  }
}
