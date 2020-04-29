import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/input_text_field_widget.dart';
import 'package:essade/widgets/long_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: essadePrimaryColor,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            color: essadePrimaryColor,
            padding: EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 40
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Codigo de Registro',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Monserrat',
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InputTextFieldWidget(
                  icon: Icons.confirmation_number,
                  boxColor: essadeDarkGray.withOpacity(0.1),
                  textColor: Colors.white,
                  placeholder: 'Ingrese código',
                  inputType: TextInputType.text,
                  placeholderColor: Colors.white54,
                ),
                SizedBox(height: 30,),
                LongButtonWidget(
                  textColor: essadePrimaryColor,
                  text: 'Registrar',
                  onPressed: () => print('Regsiter code pressed'),
                  boxColor: Colors.white,
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}
