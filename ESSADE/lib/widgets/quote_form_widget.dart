import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/models/Quote.dart';
import 'package:essade/utilities/constants.dart';
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
                  style: essadeParagraph,
                )
              ],
            )
        ),
      );
    }
    return selectableWidget;
  }

  InputBorder _myBorderErrorStyle(double borderRadius, Color color, {double width:1.0}){
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

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
                style: TextStyle(color: essadeBlack, fontFamily: 'Raleway'),
                decoration: InputDecoration(
                  hintText: 'Escriba sus comentarios',
                  hintStyle: TextStyle(color: essadeGray, fontFamily: 'Raleway'),
                  contentPadding: EdgeInsets.all(10.0),
                  enabledBorder: _myBorderErrorStyle(10.0, essadeGray.withOpacity(0.5)),
                  focusedBorder: _myBorderErrorStyle(10.0, essadePrimaryColor),
                  errorBorder: _myBorderErrorStyle(10.0, Colors.red.withOpacity(0.5)),
                  focusedErrorBorder: _myBorderErrorStyle(10.0, Colors.red.withOpacity(0.5)),
                ),
              ),
              SizedBox(height: 20),
              RaisedButton(
                onPressed: () {
                  removeErrorValidation = false;
                  if(!isServiceSelected){
                    setState(() {
                      selectableBorderColor = Colors.red.withOpacity(0.5);
                      selectableIconColor = Colors.red.withOpacity(0.8);
                    });
                  }
                  if (_formKey.currentState.validate()){

                      Firestore.instance.collection('cotizaciones').add({
                        'tipo_servicio': serviceSelected,
                        'comentario': commentInputController.text
                      }).then((result) => {
                        setState(() { serviceSelected = 'Seleccione un servicio...';}),
                        commentInputController.clear(),
                      }).catchError((error) => print(error));
                  }
                },
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: essadePrimaryColor,
                child: Text(
                  'Enviar Cotización',
                  style: btnFontStyle(Colors.white),
                ),
              )
            ]
        )
    );
  }
}
