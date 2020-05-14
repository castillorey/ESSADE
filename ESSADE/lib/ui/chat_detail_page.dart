import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class ChatDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TitleWidget(
            text: 'Chat',
            color: essadeBlack,
          ),
        ]
    );
  }
}
