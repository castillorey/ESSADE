import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/models/global.dart';
import 'package:essade/utilities/constants.dart';
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
          _title(),
          SizedBox(height: 20),
          _guideParahraph(),
          SizedBox(height: 20),
          _customCardItem('Chat', Icons.smartphone),
          SizedBox(height: 20),
          _customCardItem('Contácto telefono', Icons.phone),
          SizedBox(height: 20),
          _customCardItem('Preguntas frecuentes', Icons.help_outline),
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

  Widget _title(){
    return Align(
      alignment: Alignment.center,
      child: Text(
        'Ayuda',
        style: essadeH2(essadeBlack),
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

  Widget _customCardItem(String text, IconData icon){
    return Container(
      height: 60,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Color(0x20000000),
                blurRadius: 5,
                offset: Offset(0, 3)
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            icon,
            color: essadeDarkGray,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: essadeParagraph(color: essadeBlack),
            ),
          ),
          Icon(
            Icons.keyboard_arrow_right,
            color: essadeDarkGray,
          )
        ],
      )
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