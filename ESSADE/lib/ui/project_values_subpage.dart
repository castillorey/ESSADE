import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

class ProjectValuesSubpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _title(),
        _graph(),
        _totalBalance(),
        _movements(),
        _pendingBalance()
      ],
    );
  }


  Widget _title() => Placeholder(fallbackHeight: 50);
  Widget _graph() => Placeholder(fallbackHeight: 300);
  Widget _totalBalance() => Placeholder(fallbackHeight: 60);
  Widget _movements() {
    return  Row(
      children: <Widget>[
        Expanded(child: Placeholder(fallbackHeight: 60,)),
        Expanded(child: Placeholder(fallbackHeight: 60),)
      ],
    );
  }
  Widget _pendingBalance() => Placeholder(fallbackHeight: 60);
}
