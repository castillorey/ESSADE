import 'package:essade/utilities/constants.dart';
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
  @override
  Widget build(BuildContext context) {

    Widget _buildLoginBtn() {
      return GestureDetector(
        onTap: () => onTap(),
        child: RichText(
          text: TextSpan(
            text: actionText,
            style: TextStyle(
              color: actionTextColor,
              fontFamily: 'Raleway',
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          guideText,
          style: TextStyle(
            color: guideTextColor,
            fontFamily: 'Raleway',
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        _buildLoginBtn(),
      ],
    );
  }
}
