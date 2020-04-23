import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

class InputTextFieldWidget extends StatelessWidget {
  final String label, placeholder;
  final TextInputType inputType;
  final IconData icon;
  final Color textColor, boxColor, placeholderColor;

  InputTextFieldWidget({
    this.label = '',
    @required this.inputType,
    @required this.icon,
    @required this.placeholder,
    @required this.textColor,
    @required this.boxColor,
    @required this.placeholderColor,

  });

  @override
  Widget build(BuildContext context) {

    final tfLabelStyle = TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      fontFamily: 'Raleway',
    );

    final tfHintTextStyle = TextStyle(
      color: placeholderColor,
      fontFamily: 'Raleway',
    );

    final tfBoxDecorationStyle = BoxDecoration(
      color: boxColor,
      borderRadius: BorderRadius.circular(10.0),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (label == '')
          Text(
            label,
            style: tfLabelStyle,
          ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: tfBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            keyboardType: inputType,
            style: TextStyle(
              color: textColor,
              fontFamily: 'Raleway',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                icon,
                color: textColor,
              ),
              hintText: placeholder,
              hintStyle: tfHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
}
