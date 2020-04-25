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
  List<Project> projects = [];
  @override
  void initState() {
    super.initState();
    _query = Firestore.instance
        .collection('proyectos')
        .snapshots();
  }

  Widget _buildTotalBalance(var balance){
    return  Column(
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

  String _addDoublesFromDocuments(List<DocumentSnapshot> documents, String key){
    var result = documents
        .map((doc) => doc[key])
        .fold(0, (a, b) => a + b);
    result = NumberFormat.simpleCurrency(decimalDigits: 0).format(result);
    return result;
  }

  DropdownMenuItem _buildDropdownMenuItem(BuildContext context, DocumentSnapshot data){
    final project = Project.fromSnapshot(data);
    //print(project.toString());
    return DropdownMenuItem(
      value: project.name,
      child: ListTile(
        title: Text(project.name, style: essadeParagraph),
        subtitle: Text('${project.city}, ${project.state}', style: essadeLightfont,),
      ),
    );
  }
  String dropdownValue = 'One';
  String projectSelected = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: _query,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            final documents = snapshot.data.documents;
            documents.map((project){
              projects.add(Project.fromSnapshot(project));
            });
            print(projects);
            projectSelected = documents[0]['nombre'];
            final _balance = _addDoublesFromDocuments(documents, 'valor_total');
            final _incomes = _addDoublesFromDocuments(documents, 'ingreso');
            final _outgoings = _addDoublesFromDocuments(documents, 'egreso');
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 30.0,
              ),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/logos/essade.png', height: 100),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
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
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '¡Hola Kevin!',
                        style: essadeH2(essadeBlack),
                      ),
                    ),
                    SizedBox(height: 20),
                    ExpansionTile(
                      leading: Icon(Icons.home),
                      title: Text('Mis proyectos', style: essadeParagraph),
                      children: documents.map((proj) {
                        return _buildExpandedItem(proj['nombre'], proj['ciudad'], proj['departamento']);
                      }).toList()
                    ),
                    SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _buildTotalBalance(_balance),
                    ),
                    SizedBox(height: 20),
                    DropdownButton(
                      value: projectSelected,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(
                          color: Colors.deepPurple
                      ),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String newValue) {
                        print(newValue);
                        setState(() {
                          projectSelected = newValue;
                        });
                      },
                      items: documents.map((project){
                        return DropdownMenuItem<String>(
                          value: project['nombre'],
                          child: Text(project['nombre']),
                        );
                      }).toList()
                    ),
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
                ),
              ),
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