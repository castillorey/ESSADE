import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';
class SubtitleGuideTextWidget extends StatelessWidget {
  final String text;
  final TextAlign textAlign;

  const SubtitleGuideTextWidget({Key key, this.text, this.textAlign = TextAlign.start}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: essadeH5(essadeDarkGray),
        textAlign: textAlign,
      ),
    );
  }
}
