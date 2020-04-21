import 'package:essade/models/global.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/input_text_field_widget.dart';
import 'package:essade/widgets/long_button_widget.dart';
import 'package:essade/widgets/social_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final sLabelStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'Raleway',
  );

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- O -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          'Registrarse con',
          style: sLabelStyle,
        ),
      ],
    );
  }


  Widget _buildLoginBtn() {
    return GestureDetector(
      onTap: (){ Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage())
      );},
      child: RichText(
        text: TextSpan(
          text: 'Iniciar sesión',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Raleway',
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAlreadySigned(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Ya tiene una cuenta? ',
          style: TextStyle(
            color: essadeGray,
            fontFamily: 'Raleway',
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        _buildLoginBtn(),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                color: primaryColor,
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 50.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Registro',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Monserrat',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 25.0),
                      InputTextFieldWidget(
                        label: 'Correo',
                        inputType: TextInputType.emailAddress,
                        icon: Icons.email,
                        placeholder: 'Ingrese su correo',
                        textColor: Colors.white,
                        boxColor: essadeGray.withOpacity(0.1),
                        placeholderColor: Colors.white54,
                      ),
                      SizedBox(height: 20.0,),
                      InputTextFieldWidget(
                        label: 'Contraseña',
                        inputType: TextInputType.emailAddress,
                        icon: Icons.lock,
                        placeholder: 'Ingrese una contraseña',
                        textColor: Colors.white,
                        boxColor: essadeGray.withOpacity(0.1),
                        placeholderColor: Colors.white54,
                      ),
                      SizedBox(height: 20.0),
                      InputTextFieldWidget(
                        label: 'Repetir Contraseña',
                        inputType: TextInputType.emailAddress,
                        icon: Icons.lock,
                        placeholder: 'Repetir la contraseña',
                        textColor: Colors.white,
                        boxColor: essadeGray.withOpacity(0.1),
                        placeholderColor: Colors.white54,
                      ),
                      SizedBox(height: 20.0),
                      LongButtonWidget(
                        text: 'Registro',
                        textColor: Colors.white,
                        onPressed: () =>  print('Sign in pressed'),
                      ),
                      SizedBox(height: 10.0),
                      _buildSignInWithText(),
                      SocialButtonWidget(
                        fbLogoPath: 'assets/logos/facebook.jpg',
                        onFbPressed: () => print('Facebook login pressed'),
                        gooLogoPath: 'assets/logos/google.jpg',
                        onGooPressed: () => print('Google login pressed'),
                      ),
                      _buildAlreadySigned(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
