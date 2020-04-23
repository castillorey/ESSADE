import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/graph_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:essade/models/global.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  Stream<QuerySnapshot> _query;

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

  Widget _buildExpandedItem(String name, String city, String state){
    return ListTile(
      title: Text(name, style: essadeParagraph),
      subtitle: Text('$city, $state', style: essadeLightfont,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _query,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasData){
          var balance = snapshot.data.documents
              .map((doc) => doc['valor_total'])
              .fold(0, (a, b) => a + b);
          balance = NumberFormat.simpleCurrency(decimalDigits: 0).format(balance);
          final proyects = snapshot.data.documents.map((doc) => doc['nombre']).toList();
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 40.0,
              vertical: 40.0,
            ),
            child: Container(
              child: Column(
                children: <Widget>[
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
                    children: ListTile.divideTiles(
                      context: context,
                      tiles: [
                        _buildExpandedItem('Estudio de suelos', 'Barranquilla', 'Atlántico'),
                        _buildExpandedItem('Construcción de vivienda', 'Codazzi', 'Cesar'),
                      ]).toList()
                  ),
                  SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildTotalBalance(balance),
                  ),
                  SizedBox(height: 20),
                  ExpansionTile(
                    leading: Icon(Icons.graphic_eq),
                    title: Text('Ingresos y egresos', style: essadeParagraph),
                    children: <Widget>[
                      Container(
                        height: 250.0,
                        child: GraphWidget(),
                      )
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
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(
                    height: 20,
                    thickness: 2,
                    color: essadeGray.withOpacity(0.1),
                  )
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
    );
  }
}