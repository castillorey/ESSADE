import 'package:essade/models/global.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}



class _AboutPageState extends State<AboutPage> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Index 5: About',style: essadeTitles,)
    );
  }
}