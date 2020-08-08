import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';

class FAQDetailPage extends StatelessWidget {
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
              children: FAQ.entries.map((entry) {
                return ExpansionTile(
                    leading: Icon(Icons.help),
                    title: Text(
                      entry.key,
                      style: essadeParagraph(),
                    ),
                    children: <Widget>[
                      ListTile(
                        title: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(entry.value,
                              textAlign: TextAlign.justify,
                              style: essadeParagraph(
                                  color: essadeBlack.withOpacity(0.9))),
                        ),
                      )
                    ]);
              }).toList(),
            ),
          )
        ]);
  }
}
