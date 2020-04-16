import 'package:essade/models/global.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}



class _HelpPageState extends State<HelpPage> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Index 4: Ayuda',style: essadeTitles,)
    );
  }
}