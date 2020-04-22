import 'package:essade/models/global.dart';
import 'package:essade/ui/container_page.dart';
import 'package:essade/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'models/global.dart';
import 'auth/login_state.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => LoginState(),
      child: MaterialApp(
        title: 'Essade App',
        theme: ThemeData(
          primarySwatch: primaryMaterialColor
        ),
        routes: {
          '/': (BuildContext context) {
            var state = Provider.of<LoginState>(context);
            print('Pasando por Main');
            if(state.isLoggedIn()){
              print('Pasando por Main');
              print('Abriendo Container Page!!');
              return ContainerPage();
            } else {
              print('Abriendo Login Page!!');
              return LoginPage();
            }
          }
        },
      ),
    );
  }
}