import 'package:essade/auth/login_state.dart';
import 'package:essade/models/Value.dart';
import 'package:essade/ui/settings_biometric_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/card_item_widget.dart';
import 'package:essade/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}



class _AboutPageState extends State<AboutPage> {
  String _whoWeAreP1 ;
  String _whoWeAreP2;
  String _missionP;
  String _visionP;

  LocalAuthentication _localAuth;
  bool _isBiometricAvailable = false;
  List<Value> _valuesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _whoWeAreP1 = essadeWhoWeAreP1;
     _whoWeAreP2 = essadeWhoWeAreP2;
     _missionP = essadeMissionP;
     _visionP = essadeVisionP;

    _localAuth = LocalAuthentication();
    _localAuth.canCheckBiometrics.then((result){
      setState(() {
        _isBiometricAvailable = result;
      });
    });
    _valuesList = essadeValues;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          _whoWeAre(),
          SizedBox(height: 20),
          _mvParagraphs('Misión', _missionP),
          SizedBox(height: 10),
          _mvParagraphs('Visión', _visionP),
          SizedBox(height: 30),
          _values(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/meeting.png', height: screenSizeHeight * 0.4),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _moreSettingsItem(
                  'Visita nuestro sitio web',
                onPressed: () => _launchExternalURL('https://www.essade.com/')
              ),
              Divider(height: 5.0,thickness: 0.2, color: essadeGray),
              if (_isBiometricAvailable)
                _biometricSettingsItem()
            ],
          ),
          _logout()


        ],
      ),
    );
  }

  _launchExternalURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _biometricSettingsItem(){
    return Column(
      children: [
        _moreSettingsItem(
            'Configuración biométrica',
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
          for(int i = 0; i < _valuesList.length; i+=2)
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _valueItem(_valuesList[i].name, _valuesList[i].description, _valuesList[i].imagePath),
                  _valueItem(_valuesList[i+1].name, _valuesList[i+1].description, _valuesList[i+1].imagePath),
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
            '¿Quiénes somos?',
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