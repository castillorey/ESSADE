import 'package:essade/auth/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}



class _AboutPageState extends State<AboutPage> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
          child: Text('Sign out'),
          onPressed: (){
            Provider.of<LoginState>(context, listen: false).logout();
          }
        ),
    );
  }
}