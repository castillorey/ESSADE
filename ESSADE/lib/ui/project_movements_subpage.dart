import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/auth/login_state.dart';
import 'package:essade/models/Movement.dart';
import 'package:essade/models/Project.dart';
import 'package:essade/models/User.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/timeline_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  }
  @override
  Widget build(BuildContext context) {

    User currentUser = Provider.of<LoginState>(context, listen: false).currentUser();
    _movementsQuery = Firestore.instance
        .collection('usuarios').document(currentUser.documentID)
        .collection('proyectos').document(widget.project.documentID)
        .collection('movimientos').orderBy('fecha_creacion', descending: true).snapshots();

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
                    padding: EdgeInsets.only(top: 20.0),
                    itemBuilder: (context, index){
                      return TimelineItemWidget(
                        movement: movements[index],
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
}
