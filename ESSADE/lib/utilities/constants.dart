import 'package:flutter/material.dart';


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

essadeParagraph( {Color color = essadeBlack}) => TextStyle(
    color: color,
    fontFamily: 'Raleway',
    fontSize: 14.0,
);

final essadeLightfont = TextStyle(
  color: essadeDarkGray,
  fontFamily: 'Raleway',
  fontSize: 12.0,
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

const Color essadePrimaryColor = Color(0xFF82142d);
const Color essadeBlack = Color(0xFF262626);
const Color essadeDarkGray = Color(0xFF85878a);
const Color essadeGray = Color(0xFFa5a5aa);
const Color essadeErrorColor = Color(0xFFED4337);