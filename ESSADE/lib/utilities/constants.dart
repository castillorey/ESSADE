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

final essadeParagraph = TextStyle(
    color: essadeBlack,
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

btnFontStyle(Color color) => TextStyle(
  color: color,
  letterSpacing: 1.5,
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  fontFamily: 'Raleway',
);


Color essadePrimaryColor = Color(0xFF82142d);
Color essadeBlack = Color(0xFF262626);
Color essadeDarkGray = Color(0xFF85878a);
Color essadeGray = Color(0xFFa5a5aa);