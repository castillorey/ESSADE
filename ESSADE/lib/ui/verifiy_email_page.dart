import 'package:essade/auth/login_state.dart';
import 'package:essade/ui/detail_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/info_dialog.dart';
import 'package:essade/widgets/long_button_widget.dart';
import 'package:essade/widgets/subtitle_guide_text_widget.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VerifyEmailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DetailPage(
      onBackPressed: () => Provider.of<LoginState>(context, listen: false).logout(),
      page: Consumer<LoginState>(
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
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TitleWidget(
                text: 'Verificación de correo',
                color: essadeBlack,
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SubtitleGuideTextWidget(
                  text: 'Te hemos enviado un correo de verificación.'
                  ' Por favor revisa tu bandeja de entrada.',
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/email_verification.jpg', height: 230),
              ),
              SizedBox(height: 10),
              LongButtonWidget(
                text: 'VERIFICAR Y PROCEDER',
                textColor: Colors.white,
                backgroundColor: essadePrimaryColor,
                onPressed: () async {
                  bool isVerified = await Provider.of<LoginState>(context, listen: false).checkEmailVerification();
                  if(!isVerified){
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 3), () {
                            Navigator.of(context).pop(true);
                          });
                          return InfoDialogWidget(
                              message: 'Su correo no ha sido verificado',
                              textAlign: TextAlign.center,
                              icon: Icons.error
                          );
                        }
                    );
                  }
                },
                icon: null,
              )
            ]
        ),
      )
    );
  }
}
