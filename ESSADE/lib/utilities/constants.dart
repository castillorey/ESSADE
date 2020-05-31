import 'package:flutter/material.dart';
import 'dart:ui' as ui;

final screenSizeHeight = ui.window.physicalSize.height / ui.window.devicePixelRatio;
final screenSizeWidth = ui.window.physicalSize.width / ui.window.devicePixelRatio;

essadeTitle(Color color) => TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: color
);

essadeH3(Color color) => TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: color
);


essadeH2(Color color) => TextStyle(
  color: color,
  fontFamily: 'Montserrat',
  fontSize: 30.0,
  fontWeight: FontWeight.bold
);

essadeH4(Color color) => TextStyle(
  color: color,
  fontFamily: 'Raleway',
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
);

essadeH5(Color color) => TextStyle(
  color: color,
  fontFamily: 'Raleway',
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
);

essadeParagraph( {Color color = essadeBlack, bool bold = false, bool underlined = false}) => TextStyle(
  color: color,
  fontFamily: 'Raleway',
  fontSize: 14.0,
  fontWeight: bold ? FontWeight.bold : null,
  decoration: underlined ? TextDecoration.underline : null,
);

essadeLightfont({bool underlined = false}) => TextStyle(
  color: essadeDarkGray,
  fontFamily: 'Raleway',
  fontSize: 12.0,
  decoration: underlined ? TextDecoration.underline : null,
);

final List<String> essadeServices = [
  'Diseño',
  'Construcción',
  'Mantenimiento',
  'Remodelación'
];

btnFontStyle(Color color, {bool bold: false}) => TextStyle(
  color: color,
  letterSpacing: 1.5,
  fontSize: 16.0,
  fontWeight: bold ? FontWeight.bold : null,
  fontFamily: 'Raleway',
);

essadeBorderErrorStyle(double borderRadius, Color color, {double width:1.0}){
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: BorderSide(color: color, width: width),
  );
}

iosFontStyle({bool bold = false, double size = 16}) => TextStyle(
  fontFamily: 'SFProDisplay',
  fontWeight: bold ? FontWeight.bold : null,
  fontSize: size
);

androidFontStyle({bool bold = false, double size = 16}) => TextStyle(
    fontFamily: 'Roboto',
    fontWeight: bold ? FontWeight.bold : null,
    fontSize: size
);

Future<void> showLoadingProgressCircle(BuildContext context, GlobalKey key) async {
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

String capitalize(String string) {
  if (string == null) {
    throw ArgumentError("string: $string");
  }

  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}

enum PlatformType {
  iOS,
  android
}
enum DetailPageType {
  Chat,
  TelephoneDirectory,
  FAQ,
  About,
  MisionVision,
  Values,
  Principles,
  Policy

}

enum MainAppPages {
  SignIn,
  RegisterId,
  StepperRegister,
  Container
}
const Color essadePrimaryColor = Color(0xFF82142d);
const Color essadeBlack = Color(0xFF262626);
const Color essadeDarkGray = Color(0xFF85878a);
const Color essadeGray = Color(0xFFa5a5aa);
const Color essadeErrorColor = Color(0xFFED4337);
const Color essadeIncomeColor = Color(0xFF00B894);
const Color essadeOutgoingColor = Color(0xFFD63031);
const Color essadeRedOrangeColor = Color(0xFFFF5349);