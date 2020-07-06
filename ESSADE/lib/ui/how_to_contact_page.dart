import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/subtitle_guide_text_widget.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class HowToContactPage extends StatelessWidget {
  final String title;
  final String text;

  const HowToContactPage({Key key, this.title, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TitleWidget(
            text: title,
            color: essadeBlack,
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/lucho.png', height: screenSizeHeight * 0.35)
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SubtitleGuideTextWidget(
              text: 'Está atento a tu teléfono, '
                  'dentro de poco nos comunicaremos contigo.',
              textAlign: TextAlign.center,
            ),
          )
        ]
    );
  }
}
