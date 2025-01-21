import 'package:flutter/material.dart';
import 'package:inkpals_app/constants.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 40, color: textMainColor),
    );
  }
}
