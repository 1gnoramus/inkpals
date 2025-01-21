import 'package:flutter/material.dart';
import 'package:inkpals_app/constants.dart';

class RedNavigationButton extends StatelessWidget {
  const RedNavigationButton(
      {super.key, required this.text, required this.widgetId});
  final String text;
  final String widgetId;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
          color: reddishColor,
          borderRadius: BorderRadius.all(Radius.circular(14.0))),
      child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, widgetId);
          },
          child: Text(
            text,
            style: TextStyle(color: whitishColor),
          )),
    );
  }
}
