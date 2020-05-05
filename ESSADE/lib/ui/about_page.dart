import 'package:essade/auth/login_state.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/card_item_widget.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}



class _AboutPageState extends State<AboutPage> {
  String _whoWeAreP1 = 'ESSADE S.A.S, es una empresa constructora de obras civiles, '
      'comprometida con la excelencia, transparencia y calidad de sus proyectos.'
      '';
  String _whoWeAreP2 = 'Somos personas transformando al país, a través de la formación'
      ' integral de nuestros colaboradores e inspiración a nuestros clientes.';

  String _missionP = 'Proveer satisfacción a nuestros clientes a través de un servicio exclusivo,'
      ' mano de obra calificada y la construcción eficiente de sus proyectos de obra civil.';

  String _visionP = 'Transformar la industria de la construcción en Colombia por medio de un'
      ' servicio de calidad, confiable e innovador.';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          //TitleWidget(text: 'Sobre Nosotros',color: essadeBlack, alignment: Alignment.center),
          SizedBox(height: 10),
          _whoWeAre(),
          SizedBox(height: 20),
          _mvParagraphs('Mision', _missionP),
          SizedBox(height: 10),
          _mvParagraphs('Vision', _visionP),
          SizedBox(height: 20),
          _values()


        ],
      ),
    );
  }

  Widget _values(){
    return Container(
      color: essadePrimaryColor,
      /*decoration: BoxDecoration(
          color: essadePrimaryColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Color(0x20000000),
                blurRadius: 5,
                offset: Offset(0, 3)
            )
          ]
      ),*/
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Nuestros Valores',
              style: essadeH2(Colors.white),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _valueItem('Pasión', 'Amamos lo que hacemos', FontAwesomeIcons.heart),
                  _valueItem('Integridad', 'Somos diferentes', FontAwesomeIcons.balanceScale)
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _valueItem('Excelencia', 'No nos conformamos', FontAwesomeIcons.certificate),
                  _valueItem('Calidad', 'Nos importa cada detalle', FontAwesomeIcons.crown)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _valueItem(String title, String p, IconData icon){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FaIcon(
            icon,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: essadeH4(Colors.white),
            ),
          ),
          Text(
            p,
            textAlign: TextAlign.center,
            style: essadeParagraph(color: Colors.white),
          )
        ],
      ),
    );
  }

  Widget _mvParagraphs(String title, String p){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: essadeH2(essadeDarkGray),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 80.0, right: 80.0, top:5.0, bottom: 20.0),
            child: Divider(
              height: 5,
              thickness: 2,
              color: essadePrimaryColor,
            ),
          ),
          Text(
            p,
            textAlign: TextAlign.justify,
            style: essadeParagraph(),
          )

        ],
      ),
    );
  }

  Widget _whoWeAre(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '¿Quiénes sómos?',
            style: essadeH2(essadePrimaryColor),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
                image: AssetImage('assets/images/4775.jpg')
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text(
                  _whoWeAreP1,
                  textAlign: TextAlign.justify,
                  style: essadeParagraph(),
                ),
                Text(
                  _whoWeAreP2,
                  textAlign: TextAlign.justify,
                  style: essadeParagraph(),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _myCardWithImage(){
    return GestureDetector(
      onTap: () => print('Card tapped'),
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '¿Quiénes sómos?',
                style: essadeH2(essadeGray),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                    image: AssetImage('assets/images/4775.jpg')
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      _whoWeAreP1,
                      textAlign: TextAlign.justify,
                      style: essadeParagraph(),
                    ),
                    Text(
                      _whoWeAreP2,
                      textAlign: TextAlign.justify,
                      style: essadeParagraph(),
                    )
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
  Widget _buid1(){
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
        SizedBox(height: 20),
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