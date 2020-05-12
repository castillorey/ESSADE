import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/auth/login_state.dart';
import 'package:essade/models/Project.dart';
import 'package:essade/models/User.dart';
import 'package:essade/ui/project_detail_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/not_projects_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class QueriesPage extends StatefulWidget {
  @override
  _QueriesPageState createState() => _QueriesPageState();
}


class _QueriesPageState extends State<QueriesPage> {
  Stream<QuerySnapshot> _query;
  bool thereIsProjectSelected;
  int indexProjectSelected;
  Project projectSelected;
  List<Project> projects;

@override
  void initState() {
    super.initState();

    indexProjectSelected = 0;
    thereIsProjectSelected = false;
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = Provider.of<LoginState>(context, listen: false).currentUser();
    _query = Firestore.instance
        .collection('usuarios').document(currentUser.documentID).collection('proyectos').snapshots();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: _query,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            final documents = snapshot.data.documents;
            projects = [];
            documents.forEach((project){
              projects.add(Project.fromSnapshot(project));
            });

            if(projects.length == 0){
             return NotProjectsWidget();
            } else {
              return Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Consultar',
                      style: essadeH2(essadeBlack),
                    ),
                  ),
                  SizedBox(height: 20),
                  ExpansionTile(
                      leading: Icon(Icons.work),
                      title: Text('Mis proyectos', style: essadeParagraph(),),
                      children: projects.map((p){
                        return ListTile(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProjectDetailPage(project: p))
                            );
                          },
                          title: Text(p.name, style: essadeParagraph(color: essadeBlack.withOpacity(0.9))),
                          subtitle: Text('${p.city}, ${p.state}', style: essadeLightfont),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        );
                      }).toList()
                  ),
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
}