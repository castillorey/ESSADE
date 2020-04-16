import 'package:flutter/material.dart';
import 'package:essade/models/global.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Index 1: Home', style: essadeTitles,),
    );
  }
}