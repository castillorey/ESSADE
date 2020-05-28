import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/models/global.dart';
import 'package:essade/ui/container_page.dart';
import 'package:essade/ui/login_page.dart';
import 'package:essade/ui/register_code_page.dart';
import 'package:essade/ui/stepper_register_page.dart';
import 'package:essade/ui/verifiy_email_page.dart';
import 'package:flutter/material.dart';
import 'models/global.dart';
import 'auth/login_state.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();

    Firestore.instance
        .collection('proyectos')
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) => print(doc["nombre"])));
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    precacheImage(AssetImage('assets/images/team.png'), context);
    precacheImage(AssetImage('assets/images/4775.jpg'), context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => LoginState(),
      child: GestureDetector(
        onTap:  () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: MaterialApp(
          title: 'Essade App',
          theme: ThemeData(
            primarySwatch: primaryMaterialColor,
            canvasColor: Colors.transparent,
            scaffoldBackgroundColor: Colors.white
          ),
          routes: {
            '/': (BuildContext context) {
              var state = Provider.of<LoginState>(context);
              if(state.isLoggedIn()){
                if(state.isEmailVerified())
                  return ContainerPage();
                else
                  return VerifyEmailPage();
              }
              return LoginPage();
            },
          },
        ),
      ),
    );
  }
}