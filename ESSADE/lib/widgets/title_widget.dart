import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String text;
  final Color color;
  final TextAlign textAlign;

  const TitleWidget({Key key, this.text, this.color, this.textAlign = TextAlign.center}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: essadeH2(color),
      textAlign: textAlign,
    );
  }
}
