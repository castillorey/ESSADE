import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

class LongButtonWidget extends StatelessWidget {
  final String text;
  final Color boxColor, textColor;
  final VoidCallback onPressed;

  LongButtonWidget({
    @required this.text,
    @required this.boxColor,
    @required this.textColor,
    @required this.onPressed
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => onPressed(),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: boxColor,
        child: Text(
          text,
          style: btnFontStyle(textColor, bold: true),
        ),
      ),
    );
  }
}
