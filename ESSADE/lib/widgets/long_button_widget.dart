import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

class LongButtonWidget extends StatelessWidget {
  final String text;
  final Color textColor;
  final VoidCallback onPressed;

  LongButtonWidget({
    @required this.text,
    @required this.textColor,
    @required this.onPressed
  });

  @override
  Widget build(BuildContext context) {

    final btnStyle = TextStyle(
      color: essadePrimaryColor,
      letterSpacing: 1.5,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Raleway',
    );

    return Container(
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => onPressed(),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: textColor,
        child: Text(
          text,
          style: btnStyle,
        ),
      ),
    );
  }
}
