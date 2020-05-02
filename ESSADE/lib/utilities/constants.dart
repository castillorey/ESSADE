import 'package:flutter/material.dart';

essadeH2(color) => TextStyle(
  color: color,
  fontFamily: 'Montserrat',
  fontSize: 30.0,
  fontWeight: FontWeight.bold
);

essadeH4(color) => TextStyle(
  color: color,
  fontFamily: 'Raleway',
  fontSize: 18.0,
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