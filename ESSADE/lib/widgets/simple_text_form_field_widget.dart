import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

class SimpleTextFormFieldWidget extends StatelessWidget {
  final TextEditingController editingController;
  final VoidCallback onChanged;
  final String validationText;
  final String hintText;
  final TextInputType inputType;
  final bool obscureText;
  final String label;
  final bool validateNewPassword;


  const SimpleTextFormFieldWidget({Key key, this.editingController, this.onChanged, this.validationText, this.hintText, this.inputType, this.obscureText = false, this.label = '', this.validateNewPassword = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if(label != '')
            _label(),
          TextFormField(
            obscureText: obscureText,
            controller: editingController,
            onChanged: (text) => onChanged(),
            validator: (String value){
              if (value.isEmpty)
                return validationText;

              if(inputType == TextInputType.emailAddress)
                if(!validateEmail(value))
                  return 'Ingrese un Email válido';

              if(validateNewPassword)
                if(!validatePassword(value))
                  return 'La contraseña no cumple con todos los criterios';

              return null;
            },
            keyboardType: inputType,
            style: TextStyle(color: essadeBlack, fontFamily: 'Raleway'),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: essadeGray, fontFamily: 'Raleway'),
              contentPadding: EdgeInsets.all(18.0),
              enabledBorder: essadeBorderErrorStyle(15.0, essadeGray.withOpacity(0.5)),
              focusedBorder: essadeBorderErrorStyle(15.0, essadePrimaryColor),
              errorBorder: essadeBorderErrorStyle(15.0, essadeErrorColor),
              focusedErrorBorder: essadeBorderErrorStyle(15.0, essadePrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  _label() => Column(
    children: <Widget>[
      Text(
        label,
        style: essadeH5(essadePrimaryColor),
      ),
      SizedBox(height: 10.0),
    ],
  );

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validatePassword(String value) {
    Pattern pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

}
