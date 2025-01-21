import 'package:flutter/material.dart';
import 'package:inkpals_app/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.placeholder,
    required this.textEditController,
  });
  final String placeholder;
  final TextEditingController textEditController;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      margin: EdgeInsets.only(bottom: 10.0),
      child: TextField(
        obscureText: placeholder == 'Password' ? true : false,
        keyboardType: placeholder == 'Email'
            ? TextInputType.emailAddress
            : TextInputType.name,
        controller: textEditController,
        style: TextStyle(color: textMainColor),
        decoration: InputDecoration(
          labelText: placeholder,
          labelStyle: const TextStyle(),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: textMainColor, width: 2),
            borderRadius: const BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
        ),
      ),
    );
  }
}
