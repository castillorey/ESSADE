import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/auth/login_state.dart';
import 'package:essade/models/Project.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/graph_widget.dart';
import 'package:essade/widgets/selectable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  Stream<QuerySnapshot> _projectsQuery;
  int pickerSelectionConfirmed;
  bool thereIsProjectSelected;

  @override
  void initState() {
    super.initState();
    _projectsQuery = Firestore.instance
        .collection('proyectos')
        .snapshots();

    pickerSelectionConfirmed = 0;
    thereIsProjectSelected = false;

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

  Widget _buildExpandedItem(String name, String ciudad, String departamento){
    return ListTile(
      title: Text(name, style: essadeParagraph()),
      subtitle: Text('$ciudad, $departamento', style: essadeLightfont,),
    );
  }

  Widget _buildInfoItem(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
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
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                    'Conoce más',
                    style: essadeLightfont
                )
              ),
              Icon(Icons.play_circle_filled, size: 15,)
            ],
          )
        ],
      ),
    );
  }

  double _getActivitiesDonePercentage(Project project){
    double percentDone = 0;
    project.tasksPercentage.forEach((k,v) {
      percentDone += v;
    });
    var result = percentDone/(project.activitiesNumber * 100);
    return result;
  }

  Widget _buildProjectSelectedInfo(String _balance, String _incomes, String _outgoings, String dp, String pp){
    if(thereIsProjectSelected){
      return Column(
        children: <Widget>[
          _buildTotalBalance(_balance),
          SizedBox(height: 20),
          ExpansionTile(
            leading: Icon(Icons.graphic_eq),
            title: Text('Ingresos y egresos', style: essadeParagraph()),
            children: <Widget>[
              Container(
                height: 250.0,
                child: GraphWidget(),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Saldo', style: essadeParagraph()),
                      Text(_balance, style: essadeParagraph())
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Ingresos', style: essadeParagraph()),
                      Text(_incomes, style: essadeParagraph())
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Egresos', style: essadeParagraph()),
                      Text(_outgoings, style: essadeParagraph())
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
          SizedBox(height: 20),
          ExpansionTile(
            leading: Icon(Icons.business_center),
            title: Text('Avance de obra', style: essadeParagraph()),
            children: <Widget>[
              Container(
                height: 250.0,
                child: GraphWidget(),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('% Ejecutado', style: essadeParagraph()),
                      Text(dp, style: essadeParagraph())
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('% Por ejecutar', style: essadeParagraph()),
                      Text(pp, style: essadeParagraph())
                    ],
                  )
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
          SizedBox(height: 10),
          Divider(
            height: 20,
            thickness: 2,
            color: essadeGray.withOpacity(0.1),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text('Información estratégica', style: essadeH4(essadeDarkGray)),
          ),
          SizedBox(height: 10),
          _buildInfoItem()
        ],
      );
    } else {
      return Align(
        alignment: Alignment.center,
        child: Text(
          'Seleccione un proyecto para ver su información detallada',
          style: essadeParagraph()
        ),
      );
    }

  }

  void isProjectSelectedCallback(bool wasProjectSelected, int pickerSelected){
    setState(() {
      thereIsProjectSelected = wasProjectSelected;
      pickerSelectionConfirmed = pickerSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: _projectsQuery,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            final documents = snapshot.data.documents;
            List<Project> _projects = [];
            documents.forEach((snapshot) => _projects.add(Project.fromSnapshot(snapshot)));
            String _balance, _incomes, _outgoings, dp, pp;

            if(thereIsProjectSelected){
              _balance = NumberFormat.simpleCurrency(decimalDigits: 0)
                  .format(_projects[pickerSelectionConfirmed].price);
              _incomes = NumberFormat.simpleCurrency(decimalDigits: 0)
                  .format(_projects[pickerSelectionConfirmed].income);
              _outgoings = NumberFormat.simpleCurrency(decimalDigits: 0)
                  .format(_projects[pickerSelectionConfirmed].outgoing);

              final _donePercentage = _getActivitiesDonePercentage(_projects[pickerSelectionConfirmed]);
              final _pendingPercentage = 1 - _donePercentage;
              dp = NumberFormat.decimalPercentPattern(decimalDigits: 2)
                  .format(_donePercentage);
              pp = NumberFormat.decimalPercentPattern(decimalDigits: 2)
                  .format(_pendingPercentage);
            }

            return Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '¡Hola Kevin!',
                    style: essadeH2(essadeBlack),
                  ),
                ),
                SizedBox(height: 20),
                SelectableWidget(
                  objectKey: 'nombre',
                  documents: documents,
                  isProjectSelectedCallback: isProjectSelectedCallback,
                ),
                SizedBox(height: 20),
                _buildProjectSelectedInfo(_balance, _incomes, _outgoings, dp, pp)
              ],
            );

          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

        },
      ),
    );
  }
}