import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/auth/login_state.dart';
import 'package:essade/controllers/projects_repository.dart';
import 'package:essade/models/Project.dart';
import 'package:essade/models/User.dart';
import 'package:essade/ui/project_detail_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/not_projects_widget.dart';
import 'package:flutter/material.dart';
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
    _query = ProjectsRepository(currentUser.documentID).queryAll();
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, right: 30.0, left: 30.0),
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
                  SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/images/consult.png', height: screenSizeHeight * 0.22),
                  ),
                  Text('Mis proyectos', style: essadeH4(essadeDarkGray)),
                  SizedBox(height: 5.0),
                  Divider(
                    indent: screenSizeWidth * 0.2,
                    endIndent: screenSizeWidth * 0.2,
                    thickness: 1,
                    color: essadePrimaryColor,
                  ),
                  SizedBox(height: 5.0),
                  Flexible(
                    child: _buildTilesList(projects),
                  )
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

  _buildTilesList(List<Project> projects){
    return ListView.separated(
      shrinkWrap: true,
      itemCount: projects.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (_, i) {
        return ListTile(
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProjectDetailPage(project: projects[i]))
            );
          },
          title: Text(projects[i].name, style: essadeParagraph(color: essadeBlack.withOpacity(0.9))),
          subtitle: Text('${projects[i].city}, ${projects[i].state}', style: essadeLightfont()),
          trailing: Icon(Icons.keyboard_arrow_right),
        );
      });
  }
}