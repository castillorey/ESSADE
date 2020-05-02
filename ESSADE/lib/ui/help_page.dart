import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/models/global.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/card_item_widget.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}



class _HelpPageState extends State<HelpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController commentInputController;

  @override
  void initState() {
    super.initState();

    commentInputController = new TextEditingController();
  }

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TitleWidget(text: 'Ayuda', color: essadeBlack, alignment: Alignment.center,),
          SizedBox(height: 20),
          _guideParahraph(),
          SizedBox(height: 20),
          CardItemWidget(text: 'Chat', icon: Icons.smartphone),
          SizedBox(height: 20),
          CardItemWidget(text: 'Contácto telefono', icon: Icons.phone),
          SizedBox(height: 20),
          CardItemWidget(text: 'Preguntas frecuentes', icon: Icons.help_outline),
          SizedBox(height: 20),
          Divider(
            height: 20,
            thickness: 2,
            color: essadeGray.withOpacity(0.3),
          ),
          SizedBox(height: 20),
          _suggestions(),

        ],
      ),
    );
  }


  Widget _guideParahraph(){
    return Text(
      'Si tienes alguna inquietud por favor'
      ' comuniquese con nostros  a tráves de:',
      style: essadeH4(essadeDarkGray),
    );
  }

  InputBorder _myBorderErrorStyle(double borderRadius, Color color, {double width:1.0}){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget _suggestions(){
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

  Widget myQuoteSentWidget(String message) {
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
            return myQuoteSentWidget('Sugerencia enviada');
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
            return myQuoteSentWidget('Lo sentimos ha ocurrido un error :(');
          }
      );
    }
  }
}