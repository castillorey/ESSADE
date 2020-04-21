import 'package:essade/models/global.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/switch_loged_signed_widget.dart';
import 'package:essade/widgets/input_text_field_widget.dart';
import 'package:essade/widgets/long_button_widget.dart';
import 'package:essade/widgets/or_log_sign_in_with_widget.dart';
import 'package:essade/widgets/social_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
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
                        boxColor: essadePrimaryColor,
                        textColor: Colors.white,
                        onPressed: () =>  print('Sign in pressed'),
                      ),
                      SizedBox(height: 10.0),
                      OrLogSignInWithWidget(
                        text: 'Registrarse con',
                        textColor: Colors.white,
                      ),
                      SocialButtonWidget(
                        fbLogoPath: 'assets/logos/facebook.jpg',
                        onFbPressed: () => print('Facebook login pressed'),
                        gooLogoPath: 'assets/logos/google.jpg',
                        onGooPressed: () => print('Google login pressed'),
                      ),
                      SwitchLoggedSignedWidget(
                        guideText: '¿Ya tiene una cuenta? ',
                        guideTextColor: essadeGray,
                        actionText: 'Iniciar Sesión',
                        actionTextColor: Colors.white,
                        onTap: (){ Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage())
                        );},
                      ),
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
