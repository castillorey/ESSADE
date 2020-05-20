import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/auth/login_state.dart';
import 'package:essade/controllers/projects_repository.dart';
import 'package:essade/models/User.dart';
import 'package:essade/ui/detail_page.dart';
import 'package:essade/ui/tel_directory_detail_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/card_item_widget.dart';
import 'package:essade/widgets/info_dialog_widget.dart';
import 'package:essade/widgets/subtitle_guide_text_widget.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  @override
  void initState() {
    super.initState();

    commentInputController = new TextEditingController();
  }

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 30.0, left: 30.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TitleWidget(text: 'Ayuda', color: essadeBlack, textAlign: TextAlign.center,),
            SizedBox(height: 20),
            SubtitleGuideTextWidget(
              text: 'Si tienes alguna inquietud'
                  'por favor comuniquese con nosotros a través de:',
            ),
            SizedBox(height: 20),
            CardItemWidget(
                text: 'Chat',
                icon: FontAwesomeIcons.whatsapp,
                iconColor: Color(0xFF25D366),
                iconSize: 25,
                onTap: () => _launchWhatsAppURL()) ,
            SizedBox(height: 20),
            CardItemWidget(
                text: 'Contácto telefónico',
                icon: FontAwesomeIcons.phoneAlt,
                iconColor: essadePrimaryColor,
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailPage(
                            child: TelDirectoryDetailPage(),
                            onBackPressed: () => Navigator.of(context).pop(),
                          )
                      )
                  );
            }),
            SizedBox(height: 20),
            CardItemWidget(text: 'Preguntas frecuentes', icon: FontAwesomeIcons.question,  onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(
                        child: FAQDetailPage(),
                        onBackPressed: () => Navigator.of(context).pop(),
                      )
                  )
              );
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

  InputBorder _myBorderErrorStyle(double borderRadius, Color color, {double width:1.0}){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget _suggestionsForm(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Sugerencias',
          style: essadeH4(essadeDarkGray),
        ),
        SizedBox(height: 20),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: commentInputController,
                onChanged: (text){
                  _formKey.currentState.validate();
                },
                validator: (String value){
                  if (value.isEmpty)
                    return 'Escriba algún comentario';

                  return null;
                },
                maxLines: 10,
                keyboardType: TextInputType.text,
                style: TextStyle(color: essadeBlack, fontFamily: 'Raleway'),
                decoration: InputDecoration(
                  hintText: 'Escriba sus comentarios',
                  hintStyle: TextStyle(color: essadeGray, fontFamily: 'Raleway'),
                  contentPadding: EdgeInsets.all(10.0),
                  enabledBorder: _myBorderErrorStyle(10.0, essadeGray.withOpacity(0.5)),
                  focusedBorder: _myBorderErrorStyle(10.0, essadePrimaryColor),
                  errorBorder: _myBorderErrorStyle(10.0, essadeErrorColor),
                  focusedErrorBorder: _myBorderErrorStyle(10.0, essadePrimaryColor),
                ),
              ),
              SizedBox(height: 20.0,),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () async {

                    if (_formKey.currentState.validate()){
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
                    'Enviar Sugerencia',
                    style: btnFontStyle(Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          )
        )
      ],
    );
  }

  Future<void> _handleSuggestionSubmit(BuildContext context) async {
    try {
      showLoadingProgressCircle(context, _keyLoader);
      User currentUser = Provider.of<LoginState>(context, listen: false).currentUser();
      DocumentReference ref = await ProjectsRepository(currentUser.documentID).addSuggestion(commentInputController.text);
      if(ref == null)
        return null;
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return InfoDialogWidget(message: 'Sugerencia enviada', icon: Icons.done);
          }
      );
      commentInputController.clear();
    } catch (error) {
      print(error);
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return InfoDialogWidget(message: 'Lo sentimos ha ocurrido un error :(', icon: Icons.error);
          }
      );
    }
  }
}