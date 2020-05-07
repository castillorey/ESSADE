import 'package:essade/auth/login_state.dart';
import 'package:essade/ui/register_code_page.dart';
import 'package:essade/ui/signup_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/info_dialog.dart';
import 'package:essade/widgets/long_social_button_widget.dart';
import 'package:essade/widgets/or_log_sign_in_with_widget.dart';
import 'package:essade/widgets/simple_text_form_field_widget.dart';
import 'package:essade/widgets/switch_loged_signed_widget.dart';
import 'package:essade/widgets/input_text_field_widget.dart';
import 'package:essade/widgets/long_button_widget.dart';
import 'package:essade/widgets/social_buttons_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  LoginState _auth = LoginState();

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Center(
          child: Consumer<LoginState>(
            builder: (BuildContext context, LoginState value, Widget child){
              if(value.isLoading()){
                return CircularProgressIndicator();
              } else {
                return child;
              }
            },
            child: Stack(
              children: <Widget>[
                Container(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                'HOLA,\nBIENVENIDO',
                                style: essadeTitle(essadePrimaryColor),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            SimpleTextFormFieldWidget(
                              label: 'Usuario',
                              inputType: TextInputType.emailAddress,
                              editingController: emailInputController,
                              onChanged: () => _formKey.currentState.validate(),
                              validationText: 'Ingrese su correo electrónico',
                              hintText: 'Su correo electrónico',
                            ),
                            /*InputTextFieldWidget(
                              label: 'Correo',
                              inputType: TextInputType.emailAddress,
                              icon: Icons.email,
                              placeholder: 'Ingrese su correo',
                              textColor: essadeDarkGray,
                              boxColor: essadeGray.withOpacity(0.1),
                              placeholderColor: essadeGray,
                            ),*/
                            SimpleTextFormFieldWidget(
                              label: 'Contraseña',
                              obscureText: true,
                              inputType: TextInputType.visiblePassword,
                              editingController: passwordInputController,
                              onChanged: () => _formKey.currentState.validate(),
                              validationText: 'Ingrese su contraseña',
                              hintText: 'Su contraseña',
                            ),
                            SizedBox(height: 10.0,),
                            /*InputTextFieldWidget(
                              label: 'Contraseña',
                              inputType: TextInputType.emailAddress,
                              icon: Icons.lock,
                              placeholder: 'Ingrese su contraseña',
                              textColor: essadeDarkGray,
                              boxColor: essadeGray.withOpacity(0.1),
                              placeholderColor: essadeGray,
                            ),*/
                            SizedBox(height: 20.0),
                            LongButtonWidget(
                              text: 'Iniciar',
                              backgroundColor: essadePrimaryColor,
                              textColor: Colors.white,
                              onPressed: () {
                                if(_formKey.currentState.validate())
                                  Provider.of<LoginState>(context, listen: false)
                                      .login(context, emailInputController.text, passwordInputController.text);
                              }
                            ),
                            /*SizedBox(height: 10.0),
                            OrLogSignInWithWidget(color: essadeGray,),
                            LongSocialButtonWidget(
                              onPressed: () {
                                Provider.of<LoginState>(context, listen: false).googleLogin();
                                Navigator.of(context).pop();
                              },
                              text: 'Iniciar con Google',
                              textColor: Colors.white,
                              backgroundColor: Color(0xFF4c8bf5),
                            ),*/
                            SizedBox(height: 30),
                            SwitchLoggedSignedWidget(
                              guideText: '¿Aún no tienes cuenta? ',
                              guideTextColor: essadeDarkGray,
                              actionText: 'Registrate aquí',
                              actionTextColor: essadePrimaryColor,
                              onTap: (){
                                final isRegisterDone = Provider.of<LoginState>(context, listen: false).isRegisterCodeDone();
                                Widget registerPage = isRegisterDone ? SignUpPage() : RegisterCodePage();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => registerPage)
                                );
                              },
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}


