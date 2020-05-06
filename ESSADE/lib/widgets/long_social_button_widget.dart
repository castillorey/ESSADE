import 'dart:ffi';

import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

class LongSocialButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final Color backgroundColor;

  const LongSocialButtonWidget({Key key, this.onPressed, this.text, this.textColor, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: onPressed,
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25),
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
            _socialImage(AssetImage('assets/logos/google.jpg')),


          ],
        ),
      ),
    );
  }

  Widget _socialImage(AssetImage image){
    return Container(
      height: 35.0,
      width: 35.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
        image: DecorationImage(
          image: image,
        ),
      ),
    );
  }
}
