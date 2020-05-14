import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/subtitle_guide_text_widget.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class TelDirectoryDetailPage extends StatelessWidget {

  Map<String, String> _directory = {
    'Gerencia':'(+57) 300 393 8174',
    'G. Contable':'(+57) 313 641 6196',
    'G. de Calidad':'(+57) 300 647 2477',
    'G. Humana':'(+57) 321 506 7160',
    'G. Comercial':'(+57) 300 393 8174',
    'G. Técnica':'(+57) 300 275 2557 ',

  };
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TitleWidget(
            text: 'Directorio telefónico',
            color: essadeBlack,
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SubtitleGuideTextWidget(
                text: 'Por favor comunicate a través'
                ' de la linea que más se ajuste a tu inquietud'
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: _directory.entries.map((entry){
                return _textTelephoneInfo(entry.key, entry.value);
              }).toList(),
            )
          )
        ]
    );
  }

  Widget _textTelephoneInfo(String area, String phone){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.phone,
            color: essadePrimaryColor,
          ),
          SizedBox(width: 20),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: essadeParagraph(),
                children: <TextSpan>[
                  TextSpan(text: '$area:  ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  TextSpan(text: '$phone'),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}
