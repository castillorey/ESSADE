import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/subtitle_guide_text_widget.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class HowToContactPage extends StatelessWidget {
  final String text;
  final Widget extra;

  const HowToContactPage({Key key, this.text, this.extra}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TitleWidget(
            text: 'Cotización enviada',
            color: essadeBlack,
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/lucho.png',
                  height: screenSizeHeight * 0.35)),
          SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  text,
                  style: essadeH4(essadeDarkGray),
                  textAlign: TextAlign.center,
                ),
              )),
          if (extra != null) extra
        ]);
  }
}
