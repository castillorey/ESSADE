import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

class InfoDialogWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const InfoDialogWidget({Key key, this.message, this.icon}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, color: essadePrimaryColor),
            SizedBox(height: 15),
            Text(message, style: essadeH4(essadeBlack), textAlign: TextAlign.center,),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
    );
  }
}
