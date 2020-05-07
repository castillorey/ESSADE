import 'package:essade/utilities/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SwitchLoggedSignedWidget extends StatelessWidget {
  final String guideText, actionText;
  final Color guideTextColor, actionTextColor;
  final VoidCallback onTap;

  SwitchLoggedSignedWidget({
    @required this.guideText,
    @required this.guideTextColor,
    @required this.actionTextColor,
    @required this.actionText,
    @required this.onTap
  });

  _myGuideTextStyle(Color color) => TextStyle(
    color: color,
    fontFamily: 'Raleway',
    fontSize: 16.0,
  );
  @override
  Widget build(BuildContext context) {

    return Container(
      child: RichText(
        text: TextSpan(
            text: guideText,
            style: _myGuideTextStyle(essadeDarkGray),
            children: <TextSpan>[
              TextSpan(
                  text: actionText,
                  style: _myGuideTextStyle(essadePrimaryColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => onTap()
              )
            ]
        ),
      ),
    );
  }
}
