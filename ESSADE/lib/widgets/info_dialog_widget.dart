import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

class InfoDialogWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final TextAlign textAlign;

  const InfoDialogWidget({Key key, this.message, this.icon, this.textAlign = TextAlign.left}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, color: essadePrimaryColor),
            SizedBox(height: 10),
            Text(message, style: essadeH4(essadeBlack), textAlign: textAlign,),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
    );
  }
}
