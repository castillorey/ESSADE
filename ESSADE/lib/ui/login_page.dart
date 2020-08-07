import 'dart:io';

import 'package:essade/auth/login_state.dart';
import 'package:essade/ui/quote_start_page.dart';
import 'package:essade/ui/settings_biometric_page.dart';
import 'package:essade/ui/register_code_page.dart';
import 'package:essade/ui/reset_password_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/biometric_button_widget.dart';
import 'package:essade/widgets/custom_alert_dialog_widget.dart';
import 'package:essade/widgets/info_dialog_widget.dart';
import 'package:essade/widgets/simple_text_form_field_widget.dart';
import 'package:essade/widgets/switch_loged_signed_widget.dart';
import 'package:essade/widgets/long_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import 'detail_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  LocalAuthentication _localAuth;
  bool _isBiometricAvailable = false;
  Future<List<BiometricType>> _availableBiometricType;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localAuth = LocalAuthentication();
    _localAuth.canCheckBiometrics.then((result) {
      setState(() {
        _isBiometricAvailable = result;
      });
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Consumer<LoginState>(
          builder: (BuildContext context, LoginState value, Widget child) {
            if (value.isLoading()) {
              return Center(child: CircularProgressIndicator());
            } else {
              return child;
            }
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Center(
                  child: Container(
                    child: SafeArea(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.0,
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Image.asset('assets/logos/essade.png',
                                        height: 60),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      width: 10.0,
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                              width: 0.5, color: essadeBlack),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        child: Text(
                                          '¡Hola,\nbienvenido!',
                                          style: essadeTitle(essadeBlack),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 10.0),
                                SimpleTextFormFieldWidget(
                                  label: 'Usuario',
                                  inputType: TextInputType.emailAddress,
                                  editingController: emailInputController,
                                  onChanged: () =>
                                      _formKey.currentState.validate(),
                                  validationText:
                                      'Ingrese su correo electrónico',
                                  hintText: 'Su correo electrónico',
                                ),
                                SimpleTextFormFieldWidget(
                                  label: 'Contraseña',
                                  obscureText: true,
                                  inputType: TextInputType.visiblePassword,
                                  editingController: passwordInputController,
                                  onChanged: () =>
                                      _formKey.currentState.validate(),
                                  validationText: 'Ingrese su contraseña',
                                  hintText: 'Su contraseña',
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ResetPasswordPage())),
                                    child: Text(
                                      'Olvidé mi contraseña',
                                      style: essadeParagraph(
                                          color: essadePrimaryColor,
                                          underlined: true),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                LongButtonWidget(
                                    text: 'Iniciar',
                                    backgroundColor: essadePrimaryColor,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      if (_formKey.currentState.validate())
                                        Provider.of<LoginState>(context,
                                                listen: false)
                                            .login(
                                                context,
                                                emailInputController.text,
                                                passwordInputController.text);
                                    }),
                                SizedBox(height: 10.0),
                                GestureDetector(
                                  onTap: () => Provider.of<LoginState>(context,
                                          listen: false)
                                      .forcingDisplayGuestQuote(),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'Quiero Cotizar',
                                      style: essadeParagraph(
                                          color: essadePrimaryColor),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 40),
                                if (!Platform.isAndroid &&
                                    _isBiometricAvailable)
                                  Align(
                                    alignment: Alignment.center,
                                    child: _buildBiometricButton(),
                                  )
                              ],
                            ),
                          )),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  child: SwitchLoggedSignedWidget(
                    guideText: '¿Aún no tienes cuenta? ',
                    guideTextColor: essadeDarkGray,
                    actionText: 'Registrate aquí',
                    actionTextColor: essadePrimaryColor,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterCodePage()));
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _buildBiometricButton() {
    _availableBiometricType = _localAuth.getAvailableBiometrics();
    return FutureBuilder<List<BiometricType>>(
      future: _availableBiometricType,
      builder:
          (BuildContext context, AsyncSnapshot<List<BiometricType>> snapshot) {
        Widget result;
        var _biometricIcon, _biometricText;
        if (snapshot.data != null) {
          if (snapshot.data.contains(BiometricType.face)) {
            // Face ID.
            _biometricIcon = Icons.face;
            _biometricText = Platform.isAndroid ? 'Recon. facial' : 'Face ID';
          } else if (snapshot.data.contains(BiometricType.fingerprint)) {
            // Touch ID.
            _biometricIcon = Icons.fingerprint;
            _biometricText = Platform.isAndroid ? 'Huella' : 'Touch ID';
          }
          result = Container(
            margin: EdgeInsets.only(bottom: 15.0),
            child: Align(
                alignment: Alignment.center,
                child: BiometricButtonWidget(
                  icon: _biometricIcon,
                  text: _biometricText,
                  onPressed: () async {
                    var isActivated =
                        Provider.of<LoginState>(context, listen: false)
                            .isBiometricActivated();
                    if (!isActivated) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialogWidget(
                              context: context,
                              title: 'Activar la lectura de biométrico',
                              message:
                                  'Podrás desactivar la lectura con biométrico en el menú: '
                                  'Más > Configuración de biométrico',
                              icon: _biometricIcon,
                              onAcceptPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SettingsBiometricPage()));
                              },
                            );
                          });
                    } else {
                      bool didAuthenticate =
                          await _localAuth.authenticateWithBiometrics(
                              localizedReason:
                                  'Ingrese su huella para iniciar sesión');
                      if (didAuthenticate)
                        Provider.of<LoginState>(context, listen: false)
                            .biometricLogin(context);
                    }
                  },
                )),
          );
        } else if (snapshot.hasError) {
          showDialog(
              context: context,
              builder: (context) {
                return InfoDialogWidget(
                    message: 'Error: ${snapshot.error}', icon: Icons.error);
              });
        } else {
          result = Column(
            children: <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Cargando...'),
              )
            ],
          );
        }
        return result;
      },
    );
  }
}
