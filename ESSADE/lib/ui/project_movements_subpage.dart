import 'package:flutter/material.dart';

class ProjectMovementsSubpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //_title(),
        _activitiesList(),
      ],
    );
  }

  Widget _title() => Placeholder(fallbackHeight: 50);
  Widget _activitiesList() => Expanded(child: Placeholder());
}
