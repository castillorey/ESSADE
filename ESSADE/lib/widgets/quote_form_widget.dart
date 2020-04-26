import 'dart:io';

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
  String projectSelected;
  int pickerSelection, pickerSelectionConfirmed;
  bool serviceSelected;

  @override
  void initState() {
    super.initState();

    services = essadeServices;
    projectSelected = 'Seleccione un servicio...';
    pickerSelection = 0;
    pickerSelectionConfirmed = 0;
    serviceSelected = false;

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
                      projectSelected = services[pickerSelectionConfirmed];
                      serviceSelected = true;
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
          value: projectSelected,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          onChanged: (newValue) {
            this.setState(() {
              projectSelected = newValue;
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
                    color: essadeGray.withOpacity(0.5),
                    width: 1.0
                )
            ),
            height: 60.0,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.work,
                  color: essadeDarkGray,
                ),
                SizedBox(width: 10),
                Text(
                  projectSelected,
                  style: essadeParagraph,
                )
              ],
            )
        ),
      );
    }
    return selectableWidget;
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
                maxLines: 10,
                style: TextStyle(color: essadeBlack, fontFamily: 'Raleway'),
                decoration: InputDecoration(
                  hintText: 'Escriba sus comentarios',
                  hintStyle: TextStyle(color: essadeGray, fontFamily: 'Raleway'),
                  contentPadding: EdgeInsets.all(10.0),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: essadeGray.withOpacity(0.5), width: 1.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(color: essadePrimaryColor, width: 1.0),
                  )
                ),
              )
            ]
        )
    );
  }
}
