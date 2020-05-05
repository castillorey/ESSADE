import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/ui/detail_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/card_item_widget.dart';
import 'package:essade/widgets/subtitle_guide_text_widget.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TitleWidget(text: 'Ayuda', color: essadeBlack, alignment: Alignment.center,),
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
                          builder: (context) => DetailPage(pageType: DetailPageType.TelephoneDirectory,))
                  );
            }),
            SizedBox(height: 20),
            CardItemWidget(text: 'Preguntas frecuentes', icon: FontAwesomeIcons.question,  onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(pageType: DetailPageType.FAQ,))
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
              SizedBox(height: 20,),
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
              )
            ],
          )
        )
      ],
    );
  }

  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: Center(
                key: key,
                child: CircularProgressIndicator(),
              )
          );
        });
  }

  Widget mySuggestionSentWidget(String message) {
    return Dialog(
      child: Container(
        width: 100,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message, style: essadeH4(essadeBlack),),
            SizedBox(height: 10),
            Icon(Icons.done, color: essadePrimaryColor,)
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
    );

  }

  Future<void> _handleSuggestionSubmit(BuildContext context) async {
    try {
      showLoadingDialog(context, _keyLoader);
      DocumentReference ref = await Firestore.instance.collection('sugerencias').add({
        'comentario': commentInputController.text
      });
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close the dialoge
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return mySuggestionSentWidget('Sugerencia enviada');
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
            return mySuggestionSentWidget('Lo sentimos ha ocurrido un error :(');
          }
      );
    }
  }
}