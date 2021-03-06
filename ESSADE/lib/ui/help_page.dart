import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/auth/login_state.dart';
import 'package:essade/controllers/projects_repository.dart';
import 'package:essade/models/User.dart';
import 'package:essade/ui/detail_page.dart';
import 'package:essade/ui/tel_directory_detail_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/card_item_widget.dart';
import 'package:essade/widgets/info_dialog_widget.dart';
import 'package:essade/widgets/simple_text_form_field_widget.dart';
import 'package:essade/widgets/subtitle_guide_text_widget.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'faq_detail_page.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController commentInputController;
  GlobalKey stickyKey = GlobalKey();
  User currentUser;

  @override
  void initState() {
    super.initState();

    commentInputController = new TextEditingController();
    currentUser = Provider.of<LoginState>(context, listen: false).currentUser();
  }

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 30.0, left: 30.0),
      child: ListView(
        children: <Widget>[
          TitleWidget(
              text: 'Ayuda', color: essadeBlack, textAlign: TextAlign.center),
          SizedBox(height: 20),
          SubtitleGuideTextWidget(
            text: 'Si tiene alguna inquietud'
                ' por favor comuníquese con nosotros a través de:',
          ),
          SizedBox(height: 20),
          CardItemWidget(
              text: 'Chat',
              icon: FontAwesomeIcons.whatsapp,
              iconColor: essadeDarkGray,
              iconSize: 25,
              onTap: () => _launchWhatsAppURL()),
          SizedBox(height: 20),
          CardItemWidget(
              text: 'Preguntas frecuentes',
              icon: FontAwesomeIcons.question,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(
                              child: FAQDetailPage(),
                              onBackPressed: () => Navigator.of(context).pop(),
                            )));
              }),
          SizedBox(height: 20),
          Divider(
            height: 20,
            thickness: 2,
            color: essadeGray.withOpacity(0.3),
          ),
          SizedBox(height: 20),
          _suggestionsForm(),
        ],
      ),
    );
  }

  _launchWhatsAppURL() async {
    const url = 'http://api.whatsapp.com/send?phone=573003938174';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  InputBorder _myBorderErrorStyle(double borderRadius, Color color,
      {double width: 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  _suggestionsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Sugerencias/PQR',
          style: essadeH4(essadeDarkGray),
        ),
        SizedBox(height: 20),
        Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SimpleTextFormFieldWidget(
                  inputType: TextInputType.text,
                  editingController: commentInputController,
                  onChanged: () => _formKey.currentState.validate(),
                  validationText: 'Escriba algún comentario',
                  hintText: 'Escriba sus comentarios',
                  maxLines: 10,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  width: double.infinity,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _handleSuggestionSubmit(context);
                      }
                    },
                    padding: EdgeInsets.all(15.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: essadePrimaryColor,
                    elevation: 0.0,
                    child: Text(
                      'Enviar sugerencia',
                      style: btnFontStyle(Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
              ],
            ))
      ],
    );
  }

  Future<void> sendEmail(
      String userName, String userEmail, String description) async {
    String username = 'noreply.essade@gmail.com';
    String password = 'essade2020';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      //..recipients.add('gerencia.essade@gmail.com')
      ..recipients.add('castilloreyeskm@gmail.com')
      //..ccRecipients.addAll(['castilloreyeskm@gmail.com'])
      //..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject =
          'Nueva Sugerencia/PQR - ${DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now())}'
      ..html = "<h4>Nombre cliente:</h4>\n" +
          "<p>$userName</p>\n" +
          "<h4>Correo cliente:</h4>\n" +
          "<p>$userEmail</p>\n" +
          "<h4>Descripción:</h4>\n" +
          "<p>$description</p>\n";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' +
          sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      print('Message not sent. \n' +
          e.toString()); //print if the email is not sent
    }
  }

  Future<void> _handleSuggestionSubmit(BuildContext context) async {
    try {
      showLoadingProgressCircle(context, _keyLoader);
      DocumentReference ref = await ProjectsRepository(currentUser.documentID)
          .addSuggestion(commentInputController.text);
      if (ref == null) return null;
      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
          .pop(); //close the dialoge
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return InfoDialogWidget(
                message: 'Sugerencia enviada', icon: Icons.done);
          });
      sendEmail(
          currentUser.name, currentUser.email, commentInputController.text);
      commentInputController.clear();
    } catch (error) {
      print(error);
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return InfoDialogWidget(
                message: 'Lo sentimos ha ocurrido un error :(',
                icon: Icons.error);
          });
    }
  }
}
