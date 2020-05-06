import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/models/Quote.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/info_dialog.dart';
import 'package:essade/widgets/input_text_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  Future _buildCupertinoModalPopup(List<String> services){
    pickerSelection = pickerSelectionConfirmed;
    return showCupertinoModalPopup(context: context, builder: (context){
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Color(0xff999999),
                  width: 0.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CupertinoButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    setState(() {
                      pickerSelection = pickerSelectionConfirmed;
                    });
                    Navigator.of(context).pop();
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 5.0,
                  ),
                ),
                CupertinoButton(
                  child: Text('Hecho'),
                  onPressed: () {
                    setState(() {
                      pickerSelectionConfirmed = pickerSelection;
                      serviceSelected = services[pickerSelectionConfirmed];
                      isServiceSelected = true;
                      selectableBorderColor = essadeGray.withOpacity(0.5);
                      selectableIconColor = essadeDarkGray;
                    });
                    Navigator.of(context).pop();
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 5.0,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 320.0,
            color: Color(0xfff7f7f7),
            child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: pickerSelectionConfirmed),
                onSelectedItemChanged: (val) {
                  setState(() {
                    pickerSelection = val;
                  });
                },
                useMagnifier: true,
                magnification: 1.2,
                itemExtent: 30,
                children: services.map((value){
                  return Container(
                    alignment: Alignment.center,
                    child: Text(value),
                  );
                }).toList()
            ),
          )
        ],
      );
    });
  }

  Widget _buildSelectableComponent(List<String> services){
    Widget selectableWidget;
    if(Platform.isAndroid){
      selectableWidget = DropdownButton(
          value: serviceSelected,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          onChanged: (newValue) {
            this.setState(() {
              serviceSelected = newValue;
            });
          },
          items: services.map((value){
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList()
      );
    } else if (Platform.isIOS){
      selectableWidget = GestureDetector(
        onTap: () => _buildCupertinoModalPopup(services),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                    color: selectableBorderColor,
                    width: 1.0
                )
            ),
            height: 60.0,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.work,
                  color: selectableIconColor,
                ),
                SizedBox(width: 10),
                Text(
                  serviceSelected,
                  style: essadeParagraph(),
                )
              ],
            )
        ),
      );
    }
    return selectableWidget;
  }


   Widget myQuoteSentWidget(String message, IconData icon) {
    return Dialog(
      child: Container(
        width: 100,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message, style: essadeH4(essadeBlack),),
            SizedBox(height: 10),
            Icon(icon, color: essadePrimaryColor,)
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
    );
  }


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
              _buildSelectableComponent(services),
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
                    'Enviar Cotización',
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
      showLoadingDialog(context, _keyLoader);
      DocumentReference ref = await Firestore.instance.collection('cotizaciones').add({
        'tipo_servicio': serviceSelected,
        'comentario': commentInputController.text
      });
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close loadingCircle
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.of(context).pop(true);
            });
            return myQuoteSentWidget('Cotización enviada con exito', Icons.done);
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
            return InfoDialog(message: 'Lo sentimos ha ocurrido un error :(', icon: Icons.error);
          }
      );
    }
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
}

