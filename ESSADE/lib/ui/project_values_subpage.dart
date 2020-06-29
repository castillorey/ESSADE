import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/auth/login_state.dart';
import 'package:essade/controllers/projects_repository.dart';
import 'package:essade/models/Movement.dart';
import 'package:essade/models/Project.dart';
import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProjectValuesSubpage extends StatelessWidget {
  final Project project;
  ProjectValuesSubpage({Key key, this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildTotalPrice(),
        _buildGraph(context),
        Align(
          alignment: Alignment.topLeft,
          child: Text('Información del proyecto', style: essadeH4(essadeDarkGray)),
        ),
        _buildMovements(),
        _buildBalances()
      ],
    );
  }

  _projectValuesItem(String text, String value){
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            text,
            style: essadeH4(essadeBlack),
          ),
          Text(
            value,
            style: essadeH4(essadePrimaryColor),
          )
        ],
      ),
    );
  }

  _buildGraph(BuildContext context) {
    var _currentUser = Provider.of<LoginState>(context).currentUser();
    var _movementsQuery = ProjectsRepository(_currentUser.documentID).queryMovements(project.documentID);

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

            final chartCurrencyFormat = NumberFormat.compactSimpleCurrency(locale: 'en', decimalDigits: 0);
            List<Series<Movement, String>> _movementsData = [];
            _movementsData.add(Series(
              domainFn: (Movement movement, _) => DateFormat.MMM('en_US').format(movement.startDate.toDate()),
              measureFn: (Movement movement, _) => movement.value,
              id: 'Ingresos',
              data: _incomes,
              fillPatternFn: (_,__) => FillPatternType.solid,
              fillColorFn: (Movement movement, _) => ColorUtil.fromDartColor(essadePrimaryColor),
              labelAccessorFn: (Movement movement, _) => '${chartCurrencyFormat.format(movement.value)}'
            ));

            _movementsData.add(Series(
              domainFn: (Movement movement, _) => DateFormat.MMM('en_US').format(movement.startDate.toDate()),
              measureFn: (Movement movement, _) => movement.value,
              id: 'Egresos',
              data: _outgoings,
              fillPatternFn: (_,__) => FillPatternType.solid,
              fillColorFn: (Movement movement, _) => ColorUtil.fromDartColor(essadeGray),
              labelAccessorFn: (Movement movement, _) => '${chartCurrencyFormat.format(movement.value)}'
            ));

            final tickCurrencyFormat = BasicNumericTickFormatterSpec
                .fromNumberFormat(chartCurrencyFormat);

            result = Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  height: 250.0,
                  child: BarChart(
                    _movementsData,
                    animate: true,
                    //Set bar label decorator.
                    barRendererDecorator: new BarLabelDecorator(
                        outsideLabelStyleSpec: TextStyleSpec(color: MaterialPalette.black, fontFamily: 'Raleway'),
                        labelAnchor: BarLabelAnchor.end,
                        labelPosition: BarLabelPosition.outside
                    ),
                    barGroupingType: BarGroupingType.grouped,
                    animationDuration: Duration(seconds: 1),
                    primaryMeasureAxis: NumericAxisSpec(
                        tickFormatterSpec: tickCurrencyFormat
                    ),
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

  _buildValues(String valueName, int value) {
    final result = globalCurrencyFormat.format(value).toString().replaceAll(',', '.');
    return _projectValuesItem(valueName, result);
  }

  _buildTotalPrice() {
    final result = globalCurrencyFormat.format(project.price).toString().replaceAll(',', '.');
    return  Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Valor del proyecto',
                    style: essadeH4(essadeBlack),
                  ),
                  Text(
                    '$result',
                    style: essadeH3(essadePrimaryColor),
                  )
                ],
              )
          )
        ],
      ),
    );
  }

  _buildMovements() {
    return  Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
              child: _buildValues('Ingresos', project.income)
          ),
          Expanded(
            child: _buildValues('Egresos', project.outgoing),
          )
        ],
      ),
    );
  }

  _buildBalances(){
    final balance = project.income - project.outgoing;
    final pendingBalance = project.price - project.income;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(child: _buildValues('Saldo actual', balance)),
          Expanded(child: _buildValues('Saldo pendiente', pendingBalance))
        ],
      ),
    );
  }
}
