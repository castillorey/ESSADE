import 'package:essade/auth/login_state.dart';
import 'package:essade/ui/detail_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/custom_alert_dialog_widget.dart';
import 'package:essade/widgets/info_dialog_widget.dart';
import 'package:essade/widgets/long_button_widget.dart';
import 'package:essade/widgets/simple_text_form_field_widget.dart';
import 'package:essade/widgets/subtitle_guide_text_widget.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsBiometricPage extends StatelessWidget {
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return DetailPage(
      onBackPressed: () => Navigator.of(context).pop(),
      backButtonIcon: Icons.arrow_back,
      child: Consumer<LoginState>(
        builder: (BuildContext context, LoginState value, Widget child){
          if(value.isLoading()){
            return Container(
                color: Colors.white,
                child: Center(
                    child: CircularProgressIndicator()
                )
            );
          } else {
            return child;
          }
        },
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 10.0, left: 6.0, right: 6.0),
            child: _buildBody(context)
          ),
        ),

      ),
    );
  }

   _buildBody(BuildContext context){
    var isActivated = Provider.of<LoginState>(context, listen: false).isBiometricActivated();
    Widget result;
    if(isActivated){
      result = Column(
        children: <Widget>[
          TitleWidget(
            text: 'Desactivación de biométrico',
            color: essadeBlack,
            textAlign: TextAlign.left,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/biometric.png', height: 200),
          ),
          SubtitleGuideTextWidget(
            text: 'Ninguna huella registrada en tu dispositivo'
                ' podrá ser utilizada para ingresar de manera rápida.',
          ),
          SizedBox(height: 20.0),
          LongButtonWidget(
            text: 'Desactivar',
            textColor: Colors.white,
            backgroundColor: essadePrimaryColor,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_context){
                    return CustomAlertDialogWidget(
                      context: _context,
                      title: 'Desactivar biométrico',
                      message: '¿Estás seguro que quieres descativar el biométrico para inicio de sesión rápido?',
                      onAcceptPressed: () async {
                        await Provider.of<LoginState>(_context, listen: false).disableBiometric(context);
                      },
                    );
                  }
              );
            },
            icon: null,
          ),
          SizedBox(height: 30.0),
        ],
      );
    } else {
      result = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TitleWidget(
              text: 'Activación de biométrico',
              color: essadeBlack,
              textAlign: TextAlign.left,
            ),
            SubtitleGuideTextWidget(
              text: 'Ingresa tus credenciales para poder activar el biométrico.'
                  ' No te preocupes, solo será esta vez.',
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SimpleTextFormFieldWidget(
                    label: 'Correo',
                    inputType: TextInputType.emailAddress,
                    editingController: emailInputController,
                    onChanged: () => _formKey.currentState.validate(),
                    validationText: 'Ingrese su correo electrónico',
                    hintText: 'Correo electrónico',
                  ),
                  SimpleTextFormFieldWidget(
                    label: 'Contraseña',
                    obscureText: true,
                    inputType: TextInputType.visiblePassword,
                    editingController: passwordInputController,
                    onChanged: () => _formKey.currentState.validate(),
                    validationText: 'Ingrese su contraseña',
                    hintText: 'Su contraseña',
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            LongButtonWidget(
              text: 'Activar',
              textColor: Colors.white,
              backgroundColor: essadePrimaryColor,
              onPressed: () async {
                if(_formKey.currentState.validate()){
                  await Provider.of<LoginState>(context, listen: false)
                      .activateBiometric(context, emailInputController.text, passwordInputController.text);
                }
              },
              icon: null,
            ),
            SizedBox(height: 30.0),
          ]
      );
    }
    return result;
  }
}
