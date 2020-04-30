import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/models/Movement.dart';
import 'package:essade/models/Project.dart';
import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectMovementsSubpage extends StatefulWidget {
  final Project project;

  const ProjectMovementsSubpage({Key key, this.project}) : super(key: key);
  @override
  _ProjectMovementsSubpageState createState() => _ProjectMovementsSubpageState();
}

class _ProjectMovementsSubpageState extends State<ProjectMovementsSubpage> {
  Stream<QuerySnapshot> _movementsQuery;
  List<Movement> movements;


  @override
  void initState() {
    super.initState();
    _movementsQuery = Firestore.instance
        .collection('movimientos')
        .where('id_proyecto', isEqualTo: widget.project.id).snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text('Movimientos', style: essadeH4(essadeDarkGray)),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _movementsQuery,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasData){
              final documents = snapshot.data.documents;
              movements = [];
              documents.forEach((movement){
                movements.add(Movement.fromSnapshot(movement));
              });

              return Expanded(
                child: ListView.builder(
                    itemCount: movements.length,
                    padding: EdgeInsets.only(top: 20, left: 5, right: 5),
                    itemBuilder: (context, index){
                      return Padding(
                        padding: EdgeInsets.only(bottom: 50.0),
                        child: Row(
                          children: <Widget>[
                            _movementBadge(movements[index]),
                            _movementDate(movements[index]),
                            _movementName(movements[index])
                          ],
                        ),
                      );
                    }
                ),
              );
            } else {
              return Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
        )
      ],
    );
  }
  _showMovementModalBottomSheet(context, Movement movement){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          var date = DateFormat.yMMMd('en_US').format(movement.startDate.toDate());
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
            ),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    movement.name,
                    style: essadeH2(essadePrimaryColor),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Detalle de la actividad',
                    style: essadeH4(essadeDarkGray),
                  ),
                  SizedBox(height: 20),
                  _detailsItem('Fecha de movimiento:', date),
                  _detailsItem('Tipo de Movimiento:', movement.type),
                  _detailsItem('Descripción:', movement.description),
                ],
              ),
            ),
          );
        });
  }

  Widget _detailsItem(String label, String value){

    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: essadeParagraph(),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: essadeParagraph(color: essadeGray),
          )
        ],
      )
    );
  }

  Widget _movementBadge(Movement movement){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0,0),
                color: movement.type == 'Ingreso' ? Color(0xFF85BB65) : essadeErrorColor,
                blurRadius: 5
            )
          ]
      ),
      child: Icon(
        Icons.fiber_manual_record,
        size: 20,
        color: movement.type == 'Ingreso' ? Color(0xFF85BB65) : essadeErrorColor,
      ),
    );
  }

  Widget _movementDate(Movement movement){
    var date = DateFormat.yMMMd('en_US').format(movement.startDate.toDate());
    return Container(
        width: 100,
        padding: EdgeInsets.only(left: 8),
        child: Text(date.toString(), style: essadeLightfont,)
    );
  }

  Widget _movementName(Movement movement){
    return Expanded(
      child: GestureDetector(
        onTap: () => _showMovementModalBottomSheet(context, movement),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 5,
                    offset: Offset(0, 3)
                )
              ]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  movement.name,
                  style: essadeParagraph(color: essadeBlack),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                color: essadeDarkGray,
              )
            ],
          ),
        ),
      ),
    );
  }
}
