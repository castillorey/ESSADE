import 'package:essade/models/Project.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/graph_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectValuesSubpage extends StatelessWidget {
  final Project project;

  const ProjectValuesSubpage({Key key, this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        children: <Widget>[
          _title(),
          _graph(),
          _movements(),
          _balances()
        ],
      ),
    );
  }


  Widget _title() {
   return Align(
     child: Container(
       alignment: Alignment.topLeft,
       padding: EdgeInsets.symmetric(vertical: 10),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           Text(
             project.name,
             style: essadeH2(essadePrimaryColor),
           ),
           Text(
             '${project.city}, ${project.state}',
             style: essadeH4(essadeBlack),
           ),
         ],
       ),
     ),
   );
  }

  Widget _graph() {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: GraphWidget(),
      ),
    );
  }
  Widget _totalBalance() {
    final balance = project.income - project.outgoing;
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Saldo total',
            style: essadeH4(essadeBlack),
          ),
          Text(
            '${NumberFormat.simpleCurrency(decimalDigits: 0)
                .format(balance)}',
            style: essadeH4(essadePrimaryColor),
          )
        ],
      ),
    );
  }

  Widget _pendingBalance() {
    final pendingBalance = project.price - project.income;
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Saldo pendiente',
            style: essadeH4(essadeBlack),
          ),
          Text(
            '${NumberFormat.simpleCurrency(decimalDigits: 0)
                .format(pendingBalance)}',
            style: essadeH4(essadePrimaryColor),
          )
        ],
      ),
    );
  }

  Widget _incomes(){
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Ingresos',
            style: essadeH4(essadeBlack),
          ),
          Text(
            '${NumberFormat.simpleCurrency(decimalDigits: 0)
                .format(project.income)}',
            style: essadeH4(essadePrimaryColor),
          )
        ],
      ),
    );
  }

  Widget _outcomes(){
    return Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Egresos',
            style: essadeH4(essadeBlack),
          ),
          Text(
            '${NumberFormat.simpleCurrency(decimalDigits: 0)
                .format(project.outgoing)}',
            style: essadeH4(essadePrimaryColor),
          )
        ],
      ),
    );
  }

  Widget _movements() {
    return  Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
              child: _incomes()
          ),
          Expanded(
            child: _outcomes(),
          )
        ],
      ),
    );
  }

  Widget _balances(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(child: _totalBalance()),
          Expanded(child: _pendingBalance())
        ],
      ),
    );
  }
}
