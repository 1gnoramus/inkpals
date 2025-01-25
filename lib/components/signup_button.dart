import 'package:flutter/material.dart';
import 'package:inkpals_app/components/custom_textfield.dart';
import 'package:inkpals_app/components/description_text.dart';
import 'package:inkpals_app/constants.dart';
import 'package:inkpals_app/screens/CanvasScreen.dart';
import 'package:inkpals_app/screens/MainScreen.dart';

class SignUpButton extends StatefulWidget {
  const SignUpButton({super.key, required this.text});
  final String text;
  @override
  State<SignUpButton> createState() => _SignUpButtonState();
}

class _SignUpButtonState extends State<SignUpButton> {
  final TextEditingController emailorPhoneController = TextEditingController();

  void showLoginForm(String text) {
    String selectedOption = text == 'Google' ? 'Google' : 'Facebook';
    showModalBottomSheet(
        context: context,
        // isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 600,
            padding: EdgeInsets.symmetric(horizontal: 60.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    (widget.text == 'Facebook'
                        ? './lib/assets/facebook.png'
                        : './lib/assets/google.png'),
                    scale: 1,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: DescriptionText(text: "Login"),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Continue to ${selectedOption}'),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CustomTextField(
                      placeholder: 'Email or Phone',
                      textEditController: emailorPhoneController),
                  Container(
                    width: 300,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                        color: bluishColor,
                        borderRadius: BorderRadius.all(Radius.circular(14.0))),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, MainScreen.id);
                      },
                      child: Text(
                        'Next',
                        style: TextStyle(color: whitishColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: reddishColor,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: TextButton(
        onPressed: () {
          showLoginForm(widget.text);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: whitishColor,
                  borderRadius: BorderRadius.all(Radius.circular(50.0))),
              child: Image.asset(
                (widget.text == 'Facebook'
                    ? './lib/assets/facebook.png'
                    : './lib/assets/google.png'),
                scale: 1.5,
              ),
            ),
            Text(
              widget.text,
              style: TextStyle(color: whitishColor),
            ),
          ],
        ),
      ),
    );
  }
}
