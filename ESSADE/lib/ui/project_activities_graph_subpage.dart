import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/auth/login_state.dart';
import 'package:essade/controllers/projects_repository.dart';
import 'package:essade/models/Project.dart';
import 'package:essade/models/Task.dart';
import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProjectActivitiesGraphSubpage extends StatelessWidget {
  final Project project;

  const ProjectActivitiesGraphSubpage({Key key, this.project}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text('Gráfico de actividades', style: essadeH4(essadeDarkGray)),
        ),
        _buildGraph(context),
      ],
    );
  }

  double _getActivitiesTotalPercentageDone(List<Task> tasks){
    double totalPercentageDone = 0;
    tasks.forEach((task) => totalPercentageDone += task.percentageDone);
    var result = totalPercentageDone/(tasks.length * 100);
    return result;
  }

  _buildGraph(BuildContext context) {
    var _currentUser = Provider.of<LoginState>(context).currentUser();
    var _activitiesQuery = ProjectsRepository(_currentUser.documentID).queryActivities(project.documentID);

    return StreamBuilder(
      stream: _activitiesQuery,
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
            List<Task> _tasks = [];
            documents.forEach((snapshot) => _tasks.add(Task.fromSnapshot(snapshot)));

            final _totalPercentageDone = _getActivitiesTotalPercentageDone(_tasks);
            final _pendingPercentage = 1 - _totalPercentageDone;
            final _percentDone = NumberFormat.decimalPercentPattern(decimalDigits: 2)
                .format(_totalPercentageDone);
            final _pendingPercent = NumberFormat.decimalPercentPattern(decimalDigits: 2)
                .format(_pendingPercentage);

            List<Series<Task, String>> _tasksPercentageData = [];
            _tasksPercentageData.add(Series(
                domainFn: (Task task, _) => task.name,
                measureFn: (Task task, _) => task.percentageDone,
                id: 'Porcentaje Tareas',
                data: _tasks,
                fillPatternFn: (_,__) => FillPatternType.solid,
                fillColorFn: (Task task, _) => ColorUtil.fromDartColor(essadePrimaryColor),
                labelAccessorFn: (Task task, _) => '${task.percentageDone.toString()}%'
            ));

            return Column(
              children: <Widget>[
                Container(
                  height: 250.0,
                  child: BarChart(
                    _tasksPercentageData,
                    animate: true,
                    //Set bar label decorator.
                    barRendererDecorator: new BarLabelDecorator(
                        insideLabelStyleSpec: TextStyleSpec(color: MaterialPalette.white, fontFamily: 'Raleway'),
                        labelAnchor: BarLabelAnchor.end
                    ),
                    vertical: false,
                    barGroupingType: BarGroupingType.grouped,
                    animationDuration: Duration(seconds: 1),
                    behaviors: [
                      new PercentInjector(
                          totalType: PercentInjectorTotalType.series)
                    ],
                    // Configure the axis spec to show percentage values.
                    primaryMeasureAxis: new PercentAxisSpec(),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('% Total ejecutado', style: essadeParagraph()),
                        Text(_percentDone, style: essadeParagraph())
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('% Total por ejecutar', style: essadeParagraph()),
                        Text(_pendingPercent, style: essadeParagraph())
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10),
              ],
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
}
