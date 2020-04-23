import 'package:essade/auth/login_state.dart';
import 'package:essade/models/global.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/switch_loged_signed_widget.dart';
import 'package:essade/widgets/input_text_field_widget.dart';
import 'package:essade/widgets/long_button_widget.dart';
import 'package:essade/widgets/or_log_sign_in_with_widget.dart';
import 'package:essade/widgets/social_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'login_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: essadePrimaryColor,
      resizeToAvoidBottomPadding: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Center(
            child: Consumer<LoginState>(
              builder: (BuildContext context, LoginState value, Widget child){
                if(value.isLoading()){
                  return CircularProgressIndicator();
                } else {
                  return child;
                }
              },
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: essadePrimaryColor,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 40.0,
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
                              boxColor: Colors.white,
                              textColor: essadePrimaryColor,
                              onPressed: () =>  print('Sign in pressed'),
                            ),
                            SizedBox(height: 10.0),
                            OrLogSignInWithWidget(
                              text: 'Registrarse con',
                              textColor: Colors.white,
                            ),
                            SocialButtonWidget(
                              onFbPressed: () => print('Facebook login pressed'),
                              onGooPressed: () => Provider.of<LoginState>(context, listen: false).googleLogin(),
                            ),
                            SwitchLoggedSignedWidget(
                              guideText: '¿Ya tiene una cuenta? ',
                              guideTextColor: essadeGray,
                              actionText: 'Iniciar Sesión',
                              actionTextColor: Colors.white,
                              onTap: (){ Navigator.pop(context); },
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
              ),
            ),
          ),
        ),
      ),
    );







  }
}
