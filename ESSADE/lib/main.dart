import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/models/global.dart';
import 'package:essade/ui/container_page.dart';
import 'package:essade/ui/login_page.dart';
import 'package:essade/ui/register_code_page.dart';
import 'package:essade/ui/stepper_register_page.dart';
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
              print(state.isLoggedIn());
              if(state.isLoggedIn()){
                print('Abriendo Container Page!!');
                return ContainerPage();
              } else {
                print('Abriendo Login Page!!');
                return LoginPage();
              }
            },
            '/RegisterId': (BuildContext context) => RegisterCodePage(),
            '/StepperForm': (BuildContext context) => StepperRegisterPage()
          },
        ),
      ),
    );
  }
}