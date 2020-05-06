import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

class OrLogSignInWithWidget extends StatelessWidget {
  final Color color;

  const OrLogSignInWithWidget({Key key, this.color}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: <Widget>[
          Text(
            'O INCIAR CON',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(width: 20.0),
          Expanded(
            child: Divider(
              thickness: 0.5,
              color: color.withOpacity(0.5),
            ),
          )
        ],
      ),
    );
  }
}
