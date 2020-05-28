import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/auth/login_state.dart';
import 'package:essade/controllers/projects_repository.dart';
import 'package:essade/models/Movement.dart';
import 'package:essade/models/Project.dart';
import 'package:essade/models/Task.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/not_projects_widget.dart';
import 'package:essade/widgets/selectable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Stream<QuerySnapshot> _projectsQuery;
  int pickerSelectionConfirmed;
  bool thereIsProjectSelected;
  Stream<QuerySnapshot> _movementsQuery;
  Stream<QuerySnapshot> _activitiesQuery;
  bool _showStrategicInfo = true;
  @override
  void initState() {
    super.initState();
    pickerSelectionConfirmed = 0;
    thereIsProjectSelected = false;
  }

  void onExpansionTileToggle(bool value){
    setState(() {
      _showStrategicInfo = !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildHomepageBody();
  }
  
  Widget _buildHomepageBody(){
    var _currentUser = Provider.of<LoginState>(context, listen: false).currentUser();
    _projectsQuery = ProjectsRepository(_currentUser.documentID).queryAll();
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 30.0, left: 30.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: _projectsQuery,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            final documents = snapshot.data.documents;
            List<Project> _projects = [];
            List _projectsName = [];
            documents.forEach((snapshot) => _projects.add(Project.fromSnapshot(snapshot)));
            documents.forEach((snapshot) => _projectsName.add(Project.fromSnapshot(snapshot).name));

            if(_projects.length == 0){
              return NotProjectsWidget();
            } else {
              return Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '¡Hola ${capitalize(_currentUser.name)}!',
                      style: essadeH2(essadeBlack),
                    ),
                  ),
                  SizedBox(height: 20),
                  SelectableWidget(
                    objectKey: 'nombre',
                    documents: _projectsName,
                    initialText: 'Seleccione un proyecto...',
                    icon: Icons.card_travel,
                    borderColor: essadeGray.withOpacity(0.2),
                    onItemSelected: (item){
                      setState(() {
                        thereIsProjectSelected = item != null;
                        pickerSelectionConfirmed = item;

                        _movementsQuery = ProjectsRepository(_currentUser.documentID).queryMovements(_projects[pickerSelectionConfirmed].documentID);
                        _activitiesQuery = ProjectsRepository(_currentUser.documentID).queryActivities(_projects[pickerSelectionConfirmed].documentID);
                      });
                    },
                  ),
                  SizedBox(height: 8.0),
                  if(thereIsProjectSelected)
                    _buildProjectInfo(_projects[pickerSelectionConfirmed])
                  else
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(top: 8.0),
                        child: Text(
                            'Seleccione un proyecto para ver su información detallada',
                            style: essadeParagraph()
                        ),
                      ),
                    ),
                  SizedBox(height: 10.0),
                  Divider(
                    height: 10,
                    thickness: 2,
                    color: essadeGray.withOpacity(0.1),
                  ),
                  Visibility (
                    visible: _showStrategicInfo,
                    child: _buildStrategicInfoItem()
                  ),
                  SizedBox(height: 5.0)
                ],
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildTotalBalance(var balance){
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Saldo total',
            style: essadeH4(essadeBlack),
          ),
          Text(
            '$balance',
            style: essadeH2(essadePrimaryColor),
          )
        ],
      ),
    );
  }

  _launchInstagramTipsURL() async {
    const url = 'https://www.instagram.com/explore/tags/essadetips/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildStrategicInfoItem(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: Text('Información estratégica', style: essadeH4(essadeDarkGray)),
          ),
          SizedBox(height: 8.0),
          Row(
            children: <Widget>[
              Container(
                  width: 200,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'Aprende los mejores tips para que tu cuarto se vea mucho más grande',
                    style: essadeParagraph(),
                  )
              ),
              Icon(
                Icons.home,
                color: essadePrimaryColor,
              )
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => _launchInstagramTipsURL(),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                        'Conoce más',
                        style: essadeLightfont
                    )
                ),
              ),
              Icon(Icons.play_circle_filled, size: 15,)
            ],
          )
        ],
      ),
    );
  }

  double _getActivitiesTotalPercentageDone(List<Task> tasks){
    double totalPercentageDone = 0;
    tasks.forEach((task) => totalPercentageDone += task.percentageDone);//totalPercentageDone += task.percentageDone);
    var result = totalPercentageDone/(tasks.length * 100);
    return result;
  }

  Widget _buildProjectInfo(Project project){

    final _balance = NumberFormat.simpleCurrency(decimalDigits: 0)
        .format(project.price);
    final _incomes = NumberFormat.simpleCurrency(decimalDigits: 0)
        .format(project.income);
    final _outgoings = NumberFormat.simpleCurrency(decimalDigits: 0)
        .format(project.outgoing);

    return Flexible(
      child: ListView(
        children: <Widget>[
          _buildTotalBalance(_balance),
          SizedBox(height: 20),
          ExpansionTile(
            onExpansionChanged: (value) {
              onExpansionTileToggle(value);
            },
            leading: Icon(Icons.graphic_eq),
            title: Text('Ingresos y egresos', style: essadeParagraph()),
            children: <Widget>[
              _buildIncomesAndOutcomes(_balance, _incomes, _outgoings),
            ],
          ),
          SizedBox(height: 20),
          ExpansionTile(
            onExpansionChanged: (value) {
              onExpansionTileToggle(value);
            },
            leading: Icon(Icons.business_center),
            title: Text('Avance de obra', style: essadeParagraph()),
            children: <Widget>[
              _buildWorkProgress(),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildIncomesAndOutcomes(String balance, String incomes, String outgoings){
    return StreamBuilder(
      stream: _movementsQuery,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData)
          return Container(
              margin: EdgeInsets.symmetric(vertical: 30.0),
              child: Center(child: CircularProgressIndicator())
          );

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

        return Column(
          children: <Widget>[
            Container(
              height: 250.0,
              child: BarChart(
                _movementsData,
                animate: true,
                barGroupingType: BarGroupingType.grouped,
                animationDuration: Duration(seconds: 1),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Saldo', style: essadeParagraph()),
                    Text(balance, style: essadeParagraph())
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Ingresos', style: essadeParagraph()),
                    Text(incomes, style: essadeParagraph())
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Egresos', style: essadeParagraph()),
                    Text(outgoings, style: essadeParagraph())
                  ],
                ),
                SizedBox(height: 10),
              ],
            )
          ],
        );
      }
    );
  }

  Widget _buildWorkProgress(){
    return StreamBuilder(
      stream: _activitiesQuery,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData)
          return Container(
              margin: EdgeInsets.symmetric(vertical: 30.0),
              child: Center(child: CircularProgressIndicator())
          );

        final documents = snapshot.data.documents;
        List<Task> _tasks = [];
        documents.forEach((snapshot) => _tasks.add(Task.fromSnapshot(snapshot)));

        final _totalPercentageDone = _getActivitiesTotalPercentageDone(_tasks);
        final _pendingPercentage = 1 - _totalPercentageDone;
        final _percentDone = NumberFormat.decimalPercentPattern(decimalDigits: 2)
            .format(_totalPercentageDone);
        final _pendingpercent = NumberFormat.decimalPercentPattern(decimalDigits: 2)
            .format(_pendingPercentage);

        List<Series<Task, String>> _tasksPercentageData = [];
        _tasksPercentageData.add(Series(
          domainFn: (Task task, _) => task.name,
          measureFn: (Task task, _) => task.percentageDone,
          id: 'Porcentaje Tareas',
          data: _tasks,
          fillPatternFn: (_,__) => FillPatternType.solid,
          fillColorFn: (Task task, _) => ColorUtil.fromDartColor(essadePrimaryColor),
        ));

        return Column(
          children: <Widget>[
            Container(
              height: 250.0,
              child: BarChart(
                _tasksPercentageData,
                animate: true,
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
                    Text('% Ejecutado', style: essadeParagraph()),
                    Text(_percentDone, style: essadeParagraph())
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('% Por ejecutar', style: essadeParagraph()),
                    Text(_pendingpercent, style: essadeParagraph())
                  ],
                )
              ],
            ),
            SizedBox(height: 10),
          ],
        );
    });
  }

}