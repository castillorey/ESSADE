import 'package:flutter/material.dart';

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'Raleway',
);

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'Raleway',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF82142d),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

Color _primaryColor = new Color(0xFF82142d);