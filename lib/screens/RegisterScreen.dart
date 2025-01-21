import 'package:flutter/material.dart';
import 'package:inkpals_app/components/custom_textfield.dart';
import 'package:inkpals_app/components/description_text.dart';
import 'package:inkpals_app/components/header_text.dart';
import 'package:inkpals_app/components/signup_button.dart';
import 'package:inkpals_app/constants.dart';
import 'package:inkpals_app/screens/MainScreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static String id = 'register_screen_id';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const HeaderText(text: 'Create an account'),
              const SizedBox(
                height: 20.0,
              ),
              const DescriptionText(text: 'Sign up with'),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SignUpButton(text: 'Google'),
                  SignUpButton(text: 'Facebook')
                ],
              ),
              const SizedBox(
                height: 40.0,
              ),
              const DescriptionText(text: 'or create a new one:'),
              CustomTextField(
                  placeholder: 'Username',
                  textEditController: usernameController),
              CustomTextField(
                  placeholder: 'Email', textEditController: emailController),
              CustomTextField(
                  placeholder: 'Password',
                  textEditController: passwordController),
              Container(
                width: 300,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    color: bluishColor,
                    borderRadius: BorderRadius.all(Radius.circular(14.0))),
                child: TextButton(
                  onPressed: () {
                    String username = usernameController.text;
                    String email = emailController.text;
                    String password = passwordController.text;

                    print(
                        "Username:${username}, Email:${email}, Password:${password}");
                    Navigator.pushNamed(context, MainScreen.id);
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: whitishColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
