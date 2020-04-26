import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/auth/login_state.dart';
import 'package:essade/models/Project.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/graph_widget.dart';
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
  Stream<QuerySnapshot> _query;
  String projectSelected;
  int pickerSelection, pickerSelectionConfirmed;
  bool thereIsProjectSelected;

  @override
  void initState() {
    super.initState();
    _query = Firestore.instance
        .collection('proyectos')
        .snapshots();

    projectSelected = 'Seleccione un projecto...';
    pickerSelection = 0;
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
              thereIsProjectSelected == true ? '$balance': '----',
              style: essadeH2(essadePrimaryColor),
            )
          ],
        ),
      );
  }

  Widget _buildExpandedItem(String name, String ciudad, String departamento){
    return ListTile(
      title: Text(name, style: essadeParagraph),
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
                  style: essadeParagraph,
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
              Icon(Icons.play_circle_filled)
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

  Future _myShowCupertinoModalPopup(List<DocumentSnapshot> documents){
    pickerSelection = pickerSelectionConfirmed;
    return showCupertinoModalPopup(context: context, builder: (context){
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Color(0xff999999),
                  width: 0.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CupertinoButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    setState(() {
                      pickerSelection = pickerSelectionConfirmed;
                    });
                    Navigator.of(context).pop();
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 5.0,
                  ),
                ),
                CupertinoButton(
                  child: Text('Hecho'),
                  onPressed: () {
                    setState(() {
                      pickerSelectionConfirmed = pickerSelection;
                      projectSelected = documents[pickerSelectionConfirmed]['nombre'];
                      thereIsProjectSelected = true;
                    });
                    Navigator.of(context).pop();
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 5.0,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 320.0,
            color: Color(0xfff7f7f7),
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(initialItem: pickerSelectionConfirmed),
              onSelectedItemChanged: (val) {
                setState(() {
                  pickerSelection = val;
                });
              },
              useMagnifier: true,
              magnification: 1.2,
              itemExtent: 30,
              children: documents.map((project){
                return Container(
                  alignment: Alignment.center,
                  child: Text(project['nombre']),
                );
              }).toList()
            ),
          )
        ],
      );
    });
  }

  Widget _buildSelectableComponent(List<DocumentSnapshot> documents){
    Widget selectableWidget;
    if(Platform.isAndroid){
      selectableWidget = DropdownButton(
          value: projectSelected,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          onChanged: (newValue) {
            this.setState(() {
              projectSelected = newValue;
            });
          },
          items: documents.map((project){
            return DropdownMenuItem(
              value: project['nombre'],
              child: Text(project['nombre']),
            );
          }).toList()
      );
    } else if (Platform.isIOS){
      selectableWidget = GestureDetector(
        onTap: () => _myShowCupertinoModalPopup(documents),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: essadeGray.withOpacity(0.2),
              width: 1.0
            )
          ),
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.card_travel,
                color: essadeDarkGray,
              ),
              SizedBox(width: 10),
              Text(
                projectSelected,
                style: essadeParagraph,
              )
            ],
          )
        ),
      );
    }
    return selectableWidget;
  }

  Widget _buildProjectSelectedInfo(String _balance, String _incomes, String _outgoings, String dp, String pp){
    if(thereIsProjectSelected){
      return Column(
        children: <Widget>[
          _buildTotalBalance(_balance),
          SizedBox(height: 20),
          ExpansionTile(
            leading: Icon(Icons.graphic_eq),
            title: Text('Ingresos y egresos', style: essadeParagraph),
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
                      Text('Saldo', style: essadeParagraph),
                      Text(_balance, style: essadeParagraph)
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Ingresos', style: essadeParagraph),
                      Text(_incomes, style: essadeParagraph)
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Egresos', style: essadeParagraph),
                      Text(_outgoings, style: essadeParagraph)
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
            title: Text('Avance de obra', style: essadeParagraph),
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
                      Text('% Ejecutado', style: essadeParagraph),
                      Text(dp, style: essadeParagraph)
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('% Por ejecutar', style: essadeParagraph),
                      Text(pp, style: essadeParagraph)
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
          _buildInfoItem(),
          _buildInfoItem(),
          _buildInfoItem(),
          _buildInfoItem(),
          _buildInfoItem(),
          _buildInfoItem(),
          _buildInfoItem(),
          _buildInfoItem(),
          _buildInfoItem()
        ],
      );
    } else {
      return Align(
        alignment: Alignment.center,
        child: Text(
          'Seleccione un proyecto para ver su información detallada',
          style: essadeParagraph
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _query,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasData){
          final documents = snapshot.data.documents;
          List<Project> _projects = [];
          documents.forEach((snapshot) => _projects.add(Project.fromSnapshot(snapshot)));
          String _balance, _incomes, _outgoings, dp, pp;

          if(thereIsProjectSelected){
            _balance = NumberFormat.simpleCurrency(decimalDigits: 0)
                .format(_projects[pickerSelectionConfirmed].balance);
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

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                /*GestureDetector(
                  onTap: () => Provider.of<LoginState>(context, listen: false).logout(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: 15,
                        alignment: Alignment.topCenter,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            'Cerrar sesión',
                            style: essadeLightfont,
                          )
                      ),
                      Container(
                        height: 15,
                        child: Icon(
                          Icons.keyboard_arrow_right,
                          size: 13,
                        ),
                      )
                    ],
                  ),
                ),*/
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '¡Hola Kevin!',
                    style: essadeH2(essadeBlack),
                  ),
                ),
                SizedBox(height: 20),
                _buildSelectableComponent(documents),
                SizedBox(height: 20),
                _buildProjectSelectedInfo(_balance, _incomes, _outgoings, dp, pp)
              ],
            ),
          );

        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

      },
    );
  }
}