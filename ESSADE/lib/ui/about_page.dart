import 'package:essade/auth/login_state.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/card_item_widget.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}



class _AboutPageState extends State<AboutPage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TitleWidget(text: 'Sobre nosotros', color: essadeBlack, alignment: Alignment.center),
        SizedBox(height: 20),
        CardItemWidget(text: '¿Quiénes somos?', icon: Icons.help_outline),
        SizedBox(height: 20),
        CardItemWidget(text: 'Mision y Visión', icon: Icons.airplanemode_active),
        SizedBox(height: 20),
        CardItemWidget(text: 'Valores', icon: Icons.favorite),
        SizedBox(height: 20),
        CardItemWidget(text: 'Principios', icon: Icons.thumb_up),
        SizedBox(height: 20),
        CardItemWidget(text: 'Políticas', icon: Icons.book),
        SizedBox(height: 20,),
        GestureDetector(
          onTap: () => Provider.of<LoginState>(context, listen: false).logout(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.exit_to_app, size: 25, color: essadeDarkGray,),
              ),
              Text(
                'Cerrar sesión',
                style: essadeH4(essadeDarkGray)
              ),
            ],
          ),
        ),
      ],
    );
  }
}