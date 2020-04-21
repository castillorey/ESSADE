import 'package:flutter/material.dart';

class OrLogSignInWithWidget extends StatelessWidget {
  final String text;
  final Color textColor;

  OrLogSignInWithWidget({
    @required this.text,
    @required this.textColor
  });
  @override

  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          '- O -',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Raleway',
          ),
        ),
      ],
    );
  }
}
