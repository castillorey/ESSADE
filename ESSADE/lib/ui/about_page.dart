import 'package:essade/auth/login_state.dart';
import 'package:essade/ui/settings_biometric_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/card_item_widget.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
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
  LocalAuthentication _localAuth;
  bool _isBiometricAvailable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _localAuth = LocalAuthentication();
    _localAuth.canCheckBiometrics.then((result){
      setState(() {
        _isBiometricAvailable = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 10),
          _whoWeAre(),
          SizedBox(height: 20),
          _mvParagraphs('Misión', _missionP),
          SizedBox(height: 10),
          _mvParagraphs('Visión', _visionP),
          SizedBox(height: 30),
          _values(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/4785.jpg', height: screenSizeHeight * 0.4),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _moreSettingsItem(
                  'Échale un vistazo a nuestras políticas'
              ),
              Divider(height: 5.0,thickness: 0.2, color: essadeGray),
              _moreSettingsItem(
                  'Conóce nuestros principios'
              ),
              Divider(height: 5.0, thickness: 0.2, color: essadeGray),
              if (_isBiometricAvailable)
                _biometricSettingsItem()
            ],
          ),
          _logout()


        ],
      ),
    );
  }

  _biometricSettingsItem(){
    return Column(
      children: [
        _moreSettingsItem(
            'Configuración biométrico',
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsBiometricPage()));
            }
        ),
        Divider(height: 5, thickness: 0.2, color: essadeBlack),
      ],
    );
  }

  Widget _logout(){
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => Provider.of<LoginState>(context, listen: false).logout(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(Icons.exit_to_app, color: essadeErrorColor, size: 20,),
                  ),
                  Text(
                      'Cerrar sesión',
                      style: essadeParagraph(color: essadeErrorColor)
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _moreSettingsItem(String text, {Function onPressed}){
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              text,
              style: essadeParagraph(color: essadeDarkGray),
            ),
            SizedBox(width: 10),
            Icon(Icons.keyboard_arrow_right, color: essadeGray, size: 15,),
          ],
        ),
      ),
    );
  }

  Widget _values(){
    return Container(
      color: essadePrimaryColor,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Nuestros valores',
            style: essadeH2(Colors.white),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top:10.0, bottom: 5.0),
            child: Divider(
              height: 5,
              thickness: 2,
              color: Colors.white,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _valueItem('Pasión', 'Amamos lo que hacemos', 'assets/values/heart.png'),
                _valueItem('Integridad', 'Somos diferentes', 'assets/values/integrity.png')
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _valueItem('Excelencia', 'No nos conformamos', 'assets/values/excelence.png'),
                _valueItem('Calidad', 'Nos importa cada detalle', 'assets/values/qa.png')
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _valueItem('Liderazgo', 'Vamos un paso adelante', 'assets/values/lead.png'),
                _valueItem('Trasparencia', 'Generamos confianza', 'assets/values/transparency.png')
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _valueItem('Compromiso', 'Planificamos con tus necesidades', 'assets/values/hands.png'),
                _valueItem('Servicio', 'Eres nuestra prioridad', 'assets/values/service.png')
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _valueItem(String title, String p, String imagePath){
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(imagePath, height: 35.0),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 10.0),
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
            style: essadeH2(essadeBlack),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/team.png', height: screenSizeHeight * 0.35)
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                Text(
                  _whoWeAreP1,
                  textAlign: TextAlign.justify,
                  style: essadeParagraph(),
                ),
                SizedBox(height: 5.0),
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

}