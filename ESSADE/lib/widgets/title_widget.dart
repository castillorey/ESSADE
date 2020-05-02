import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Alignment alignment;

  const TitleWidget({Key key, this.text, this.color, this.alignment}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Text(
        text,
        style: essadeH2(color),
      ),
    );
  }
}
