import 'package:essade/auth/login_state.dart';
import 'package:essade/ui/register_code_page.dart';
import 'package:essade/ui/signin_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/or_log_sign_in_with_widget.dart';
import 'package:essade/widgets/switch_loged_signed_widget.dart';
import 'package:essade/widgets/input_text_field_widget.dart';
import 'package:essade/widgets/long_button_widget.dart';
import 'package:essade/widgets/social_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                        vertical: 80.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              color: essadePrimaryColor,
                              fontFamily: 'Monserrat',
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 30.0),
                          InputTextFieldWidget(
                            label: 'Correo',
                            inputType: TextInputType.emailAddress,
                            icon: Icons.email,
                            placeholder: 'Ingrese su correo',
                            textColor: essadeDarkGray,
                            boxColor: essadeGray.withOpacity(0.1),
                            placeholderColor: essadeGray,
                          ),
                          SizedBox(height: 20.0,),
                          InputTextFieldWidget(
                            label: 'Contraseña',
                            inputType: TextInputType.emailAddress,
                            icon: Icons.lock,
                            placeholder: 'Ingrese una contraseña',
                            textColor: essadeDarkGray,
                            boxColor: essadeGray.withOpacity(0.1),
                            placeholderColor: essadeGray,
                          ),
                          SizedBox(height: 20.0),
                          LongButtonWidget(
                            text: 'Iniciar sesión',
                            boxColor: essadePrimaryColor,
                            textColor: Colors.white,
                            onPressed: () =>  print('Sign in pressed'),
                          ),
                          SizedBox(height: 10.0),
                          OrLogSignInWithWidget(
                            text: 'Iniciar con',
                            textColor: essadeGray,
                          ),
                          SocialButtonWidget(
                            onFbPressed: () => print('Facbook pressed'),
                            onGooPressed: () => Provider.of<LoginState>(context, listen: false).googleLogin(),
                          ),
                          SwitchLoggedSignedWidget(
                            guideText: '¿Aún no tiene cuenta? ',
                            guideTextColor: essadeDarkGray,
                            actionText: 'Registrarme',
                            actionTextColor: essadePrimaryColor,
                            onTap: (){ Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegisterCodePage())
                            );},
                          ),
                        ],
                      )
                    ),
                  ),
                ],
              )
            )
          ),
        ),
      ),
    );
  }
}


