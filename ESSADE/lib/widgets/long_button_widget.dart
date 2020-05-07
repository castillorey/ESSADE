import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

class LongButtonWidget extends StatelessWidget {
  final String text;
  final Color backgroundColor, textColor;
  final VoidCallback onPressed;
  final IconData icon;

  LongButtonWidget({
    @required this.text,
    @required this.backgroundColor,
    @required this.textColor,
    // ignore: avoid_init_to_null
    @required this.onPressed, this.icon = null
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: onPressed,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              text,
              style: btnFontStyle(textColor, bold: true),
            ),
            Icon(icon != null ? icon : Icons.arrow_forward, color: textColor)
          ],
        ),
      ),
    );
  }
}
