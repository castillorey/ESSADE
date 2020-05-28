import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/auth/login_state.dart';
import 'package:essade/models/Movement.dart';
import 'package:essade/models/Project.dart';
import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProjectValuesSubpage extends StatelessWidget {
  final Project project;


  const ProjectValuesSubpage({Key key, this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //_title(),
        Align(
          alignment: Alignment.topLeft,
          child: Text('General', style: essadeH4(essadeDarkGray)),
        ),
        _buildGraph(context),
        _buildMovements(),
        _buildBalances()
      ],
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

  Widget _buildGraph(BuildContext context) {
    var _currentUser = Provider.of<LoginState>(context).currentUser();
    var _movementsQuery = Firestore.instance
        .collection('usuarios').document(_currentUser.documentID)
        .collection('proyectos').document(project.documentID)
        .collection('movimientos').snapshots();

    return StreamBuilder(
      stream: _movementsQuery,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        Widget result;
        if (snapshot.hasError) {
          result = Column(
            children: <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ],
          );
        } else {
          if(snapshot.hasData){
            final documents = snapshot.data.documents;
            List<Movement> _movements = [];
            documents.forEach((snapshot) => _movements.add(Movement.fromSnapshot(snapshot)));

            List<Movement> _incomes = [];
            List<Movement> _outgoings = [];

            _movements.forEach((item){
              if(item.type == 'Egreso')
                _outgoings.add(item);
              else
                _incomes.add(item);
            });

            List<Series<Movement, String>> _movementsData = [];
            _movementsData.add(Series(
              domainFn: (Movement movement, _) => DateFormat.MMM('en_US').format(movement.startDate.toDate()),
              measureFn: (Movement movement, _) => movement.value,
              id: 'Ingresos',
              data: _incomes,
              fillPatternFn: (_,__) => FillPatternType.solid,
              fillColorFn: (Movement movement, _) => ColorUtil.fromDartColor(essadePrimaryColor),
            ));

            _movementsData.add(Series(
              domainFn: (Movement movement, _) => DateFormat.MMM('en_US').format(movement.startDate.toDate()),
              measureFn: (Movement movement, _) => movement.value,
              id: 'Egresos',
              data: _outgoings,
              fillPatternFn: (_,__) => FillPatternType.solid,
              fillColorFn: (Movement movement, _) => ColorUtil.fromDartColor(essadeGray),
            ));

            result = Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  height: 250.0,
                  child: BarChart(
                    _movementsData,
                    animate: true,
                    barGroupingType: BarGroupingType.grouped,
                    animationDuration: Duration(seconds: 1),
                  ),
                ),
              ),
            );
          } else {
            result = Center(
              child: CircularProgressIndicator(),
            );
          }
        }
        return result;
      },
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

  Widget _buildMovements() {
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

  Widget _buildBalances(){
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
