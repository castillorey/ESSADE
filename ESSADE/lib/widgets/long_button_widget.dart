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
    @required this.onPressed, this.icon = Icons.arrow_forward
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
          mainAxisAlignment: icon != null ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: btnFontStyle(textColor, bold: true),
            ),
            if(icon != null)
              Icon(icon, color: textColor)
          ],
        ),
      ),
    );
  }
}
