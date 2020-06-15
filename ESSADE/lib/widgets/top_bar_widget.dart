import 'dart:io';

import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

class TopBarWidget extends StatelessWidget {
  final bool showBackButton;

  const TopBarWidget({Key key, this.showBackButton : true}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var marginTop = 30.0;
    if (Platform.isAndroid)
      marginTop = 40.0;
    return Row(
      children: [
        if (showBackButton)
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 32.0,
              margin: EdgeInsets.only(top: marginTop),
              padding: EdgeInsets.only(left: 15.0),
              child: Icon(Icons.arrow_back, color: essadeBlack),
            ),
          )
        else
          Container(
            width: 32.0,
          ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: marginTop),
            child: Image.asset('assets/logos/essade.png', height: 60),
          ),
        ),
        Container(
          width: 32.0,
        )
      ],
    );
  }
}
