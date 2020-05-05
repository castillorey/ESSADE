import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CardItemWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function onTap;

   const CardItemWidget({Key key, this.text, this.icon, this.onTap}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 60,
          margin: EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 5,
                    offset: Offset(0, 3)
                )
              ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if(icon != null)
                Icon(icon, color: essadeDarkGray,)
              else
                FaIcon(FontAwesomeIcons.whatsapp, color: Color(0xFF25D366), size: 30),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: essadeParagraph(color: essadeBlack),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: essadeDarkGray,
              )
            ],
          )
      ),
    );
  }
}
