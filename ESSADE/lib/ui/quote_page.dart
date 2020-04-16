import 'package:essade/models/global.dart';
import 'package:flutter/material.dart';

class QuotePage extends StatefulWidget {
  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Index 2: Quote', style: essadeTitles,)
    );
  }
}