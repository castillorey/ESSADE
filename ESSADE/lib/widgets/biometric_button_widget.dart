import 'package:essade/auth/login_state.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/custom_alert_dialog_widget.dart';
import 'package:essade/widgets/info_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class BiometricButtonWidget extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String text;

  const BiometricButtonWidget({Key key, this.onPressed, this.icon, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        child: Column(
          children: <Widget>[
            _buildButton(icon, text),
          ],
        ),
      ),
    );
  }

  _buildButton(IconData icon, String text){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          color: essadePrimaryColor,
          size: 50.0,
        ),
        SizedBox(height: 5.0),
        Text(
            'Ingresar con $text',
          style: essadeH5(essadeDarkGray),
        )
      ],
    );
  }
}
