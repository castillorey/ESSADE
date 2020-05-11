import 'package:essade/auth/login_state.dart';
import 'package:essade/models/global.dart';
import 'package:essade/ui/stepper_register_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/long_social_button_widget.dart';
import 'package:essade/widgets/switch_loged_signed_widget.dart';
import 'package:essade/widgets/input_text_field_widget.dart';
import 'package:essade/widgets/long_button_widget.dart';
import 'package:essade/widgets/or_log_sign_in_with_widget.dart';
import 'package:essade/widgets/social_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: essadePrimaryColor,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
            brightness: Brightness.light,
            elevation: 0.0,
          ),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: _buildBody()
          )
      ),
    );
  }

  Widget _buildBody(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 1.5,
          child: Text(
            '¿LISTO PARA CREAR TU CUENTA?',
            style: essadeTitle(Colors.white),
          ),
        ),
        SizedBox(height: 30.0),
        LongSocialButtonWidget(
          onPressed: () {
            //Provider.of<LoginState>(context, listen: false).googleLogin();
            Navigator.of(context).pop();
          },
          text: 'Registro con Google',
          textColor: Colors.white,
          backgroundColor: Color(0xFF4c8bf5),
        ),
        OrLogSignInWithWidget(color: Colors.white),
        LongButtonWidget(
          text: 'Registro con Email',
          backgroundColor: Colors.white,
          textColor: essadePrimaryColor,
          onPressed: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StepperRegisterPage(''))
            );*/
          },
        ),
      ],
    );
  }

  Widget _build_1(){
    Scaffold(
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
                      child: Form(
                        key: _formKey,
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
                              backgroundColor: Colors.white,
                              textColor: essadePrimaryColor,
                              onPressed: () =>  print('Sign in pressed'),
                            ),
                            SizedBox(height: 10.0),
                            OrLogSignInWithWidget(),
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
