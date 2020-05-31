import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

class NotProjectsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Uy, parece que aun no tienes proyectos',
            textAlign: TextAlign.center,
            style: essadeH3(essadeBlack),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/empty.png', height: 300),
          ),
        ],
      ),
    );
  }
}
