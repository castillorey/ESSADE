import 'dart:io';

import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class CustomAlertDialogWidget extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String message;
  final IconData icon;
  final Function onAcceptPressed;

  const CustomAlertDialogWidget({Key key, this.title, this.icon = null, this.message, this.context, this.onAcceptPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildAlertDialog(),
    );
  }

  _buildAlertDialog(){
    if(Platform.isAndroid){
      return AlertDialog(
        title: Text(title, style: androidFontStyle(bold: true)),
        content: Container(
          child: Column(
            children: <Widget>[
              if(icon != null)
                Icon(
                  icon,
                  color: essadeRedOrangeColor,
                  size: 50.0,
                ),
              SizedBox(height: 10.0),
              Text(message, style: androidFontStyle())
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
              child: Text('Cancelar')
          ),
          FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                onAcceptPressed();
                },
              child: Text('Aceptar')
          )
        ],
      );
    } else {
      return CupertinoAlertDialog(
        title: Text(title, style: iosFontStyle(bold: true)),
        content: Container(
          margin: EdgeInsets.only(top: 10.0),
          child: Column(
            children: <Widget>[
              if(icon != null)
                Icon(
                  icon,
                  color: essadeRedOrangeColor,
                  size: 50.0,
                ),
              SizedBox(height: 10.0),
              Text(message, style: iosFontStyle())
            ],
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Text('Cancelar')
          ),
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              onAcceptPressed();
              },
            child: Text('Aceptar')
          )
        ],
      );
    }
  }
}
