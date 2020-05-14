import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class FAQDetailPage extends StatelessWidget {
  Map<String, String> _FAQs = {
    '¿Qué le pasó a lúnes?':'Se la pillaron afuera en cuarentena',
    '¿Por qué el agua moja?':'Por que así quiso Diosito',
    '¿Pa dónde se fue la O?':'A comer tamáles y se engordó',
    '¿De qué color es el caballo blanco de Simon Bolivar?':'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent urna ex, gravida ac lacus eget, sodales mattis eros. ',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TitleWidget(
            text: 'FAQ',
            color: essadeBlack,
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: _FAQs.entries.map((entry){
                return ExpansionTile(
                    leading: Icon(Icons.help),
                    title: Text(entry.key, style: essadeParagraph(),),
                    children: <Widget>[
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(entry.value, textAlign: TextAlign.justify, style: essadeParagraph(color: essadeBlack.withOpacity(0.9))),
                        ),
                        //subtitle: Text('${p.city}, ${p.state}', style: essadeLightfont),
                        //trailing: Icon(Icons.keyboard_arrow_right),
                      )
                    ]
                );
              }).toList(),
            ),
          )
        ]
    );
  }
}
