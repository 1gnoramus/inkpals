import 'package:flutter/material.dart';
import 'package:inkpals_app/constants.dart';

class DescriptionText extends StatelessWidget {
  const DescriptionText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, color: textMainColor),
    );
  }
}
