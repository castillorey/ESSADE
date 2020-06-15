import 'package:essade/auth/login_state.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/info_dialog_widget.dart';
import 'package:essade/widgets/long_button_widget.dart';
import 'package:essade/widgets/simple_text_form_field_widget.dart';
import 'package:essade/widgets/subtitle_guide_text_widget.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:essade/widgets/top_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatelessWidget {
  TextEditingController emailInputController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Consumer<LoginState>(
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
          child: Column(
            children: [
              TopBarWidget(),
              Divider(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 40.0),
                child: Column(
                    children: <Widget>[
                      TitleWidget(
                        text: 'Restablece tu contraseña',
                        color: essadeBlack,
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 10),
                      SubtitleGuideTextWidget(
                        text: 'Ingresa el correo electrónico asociado con tu cuenta'
                            ' y te enviaremos las instrucciones para restablecer tu contraseña.',
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
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      LongButtonWidget(
                        text: 'Enviar correo',
                        textColor: Colors.white,
                        backgroundColor: essadePrimaryColor,
                        onPressed: () async {
                          if(_formKey.currentState.validate()){
                            await Provider.of<LoginState>(context, listen: false).resetPassword(emailInputController.text);
                            showDialog(
                                context: context,
                                builder: (_context) {
                                  Future.delayed(Duration(seconds: 4), () {
                                    Navigator.of(_context).pop(true);
                                    Navigator.of(context).pop();
                                  });
                                  return InfoDialogWidget(
                                      message: '¡Listo!\nTe hemos enviado las instrucciones. Ve corriendo y revisa tu correo',
                                      textAlign: TextAlign.center,
                                      icon: Icons.done
                                  );
                                }
                            );
                          }
                        },
                        icon: null,
                      )
                    ]
                ),
              ),
            ],
          ),
      ),
    );
  }
}
