import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/auth/login_state.dart';
import 'package:essade/controllers/projects_repository.dart';
import 'package:essade/models/Quote.dart';
import 'package:essade/models/User.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/info_dialog_widget.dart';
import 'package:essade/widgets/input_text_field_widget.dart';
import 'package:essade/widgets/selectable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuoteFormWidget extends StatefulWidget {
  @override
  _QuoteFormWidgetState createState() => _QuoteFormWidgetState();
}

class _QuoteFormWidgetState extends State<QuoteFormWidget> {
  List<String> services;
  String serviceSelected;
  String quoteComment;
  int pickerSelection, pickerSelectionConfirmed;
  bool isServiceSelected;
  bool removeErrorValidation;
  Quote quote;
  Color selectableBorderColor;
  Color selectableIconColor;

  TextEditingController commentInputController;
  bool quoteIsLoading = true;
  
  @override
  void initState() {
    super.initState();

    services = essadeServices;
    pickerSelection = 0;
    pickerSelectionConfirmed = 0;
    serviceSelected = 'Seleccione un servicio...';
    isServiceSelected = false;
    removeErrorValidation = false;

    commentInputController = new TextEditingController();
    selectableBorderColor = essadeGray.withOpacity(0.5);
    selectableIconColor = essadeDarkGray;
  }

  final _formKey = GlobalKey<FormState>();

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Cotizar',
                  style: essadeH2(essadeBlack),
                ),
              ),
              SizedBox(height: 20),
              SelectableWidget(
                objectKey: 'nombre',
                documents: services,
                initialText: 'Seleccione un servicio...',
                icon: Icons.work,
                borderColor: selectableBorderColor,
                onItemSelected: (item){
                  setState(() {
                    serviceSelected = services[item];
                    isServiceSelected = item != null;
                    selectableBorderColor = essadeGray.withOpacity(0.5);
                    selectableIconColor = essadeDarkGray;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: commentInputController,
                onChanged: (text){
                  removeErrorValidation = true;
                  _formKey.currentState.validate();
                },
                validator: (String value){
                  if (removeErrorValidation)
                    return null;

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
                  enabledBorder: essadeBorderErrorStyle(10.0, essadeGray.withOpacity(0.5)),
                  focusedBorder: essadeBorderErrorStyle(10.0, essadePrimaryColor),
                  errorBorder: essadeBorderErrorStyle(10.0, essadeErrorColor),
                  focusedErrorBorder: essadeBorderErrorStyle(10.0, essadePrimaryColor),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: () async {
                    removeErrorValidation = false;
                    if(!isServiceSelected){
                      setState(() {
                        selectableBorderColor = essadeErrorColor;
                        selectableIconColor = essadeErrorColor;
                      });
                    }
                    if (_formKey.currentState.validate() && isServiceSelected){
                      _handleQuoteSubmit(context);
                    }
                  },
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: essadePrimaryColor,
                  elevation: 0.0,
                  child: Text(
                    'Enviar cotización',
                    style: btnFontStyle(Colors.white),
                  ),
                ),
              )
            ]
        )
    );
  }

  Future<void> _handleQuoteSubmit(BuildContext context) async {
    try {
      showLoadingProgressCircle(context, _keyLoader);
      User currentUser = Provider.of<LoginState>(context, listen: false).currentUser();
      DocumentReference ref = await ProjectsRepository(currentUser.documentID).addQuote(serviceSelected, commentInputController.text);
      if(ref == null)
        return null;

      print(ref);
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close loadingCircle
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return InfoDialogWidget(message: 'Cotización enviada', icon: Icons.done);
          }
      );
      setState(() { serviceSelected = 'Seleccione un servicio...';});
      commentInputController.clear();
    } catch (error) {
      print(error);
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return InfoDialogWidget(message: 'Lo sentimos ha ocurrido un error :(', icon: Icons.error);
          }
      );
    }
  }
}

