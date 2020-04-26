import 'package:essade/models/global.dart';
import 'package:essade/widgets/quote_form_widget.dart';
import 'package:flutter/material.dart';

class QuotePage extends StatefulWidget {
  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {

  @override
  Widget build(BuildContext context) {
    return QuoteFormWidget();
  }
}