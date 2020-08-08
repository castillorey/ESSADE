import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/auth/login_state.dart';
import 'package:essade/controllers/projects_repository.dart';
import 'package:essade/models/Activity.dart';
import 'package:essade/models/Project.dart';
import 'package:essade/models/User.dart';
import 'package:essade/ui/activity_detail_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'detail_page.dart';

class ProjectActivitiesSubpage extends StatefulWidget {
  final Project project;

  const ProjectActivitiesSubpage({Key key, this.project}) : super(key: key);

  @override
  _ProjectActivitiesSubpageState createState() =>
      _ProjectActivitiesSubpageState();
}

class _ProjectActivitiesSubpageState extends State<ProjectActivitiesSubpage> {
  Stream<QuerySnapshot> _activitiesQuery;
  List<Activity> activities;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = "es";
    initializeDateFormatting();

    User _currentUser =
        Provider.of<LoginState>(context, listen: false).currentUser();
    _activitiesQuery = ProjectsRepository(_currentUser.documentID)
        .queryActivities(widget.project.documentID);

    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child:
              Text('Listado de actividades', style: essadeH4(essadeDarkGray)),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _activitiesQuery,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              final documents = snapshot.data.documents;
              activities = [];
              documents.forEach((activity) {
                activities.add(Activity.fromSnapshot(activity));
              });
              return Expanded(
                child: ListView.builder(
                    itemCount: activities.length,
                    padding: EdgeInsets.only(
                      top: 20,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: Row(
                          children: <Widget>[_activityName(activities[index])],
                        ),
                      );
                    }),
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

  _showActivityModalBottomSheet(context, Activity activity) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          var date =
              DateFormat.MMMd().add_jm().format(activity.start_date.toDate());
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    activity.name,
                    style: essadeH2(essadePrimaryColor),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Detalle de la actividad',
                    style: essadeH4(essadeDarkGray),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        _detailsItem('Fecha de actividad', date),
                        _detailsItem('Descripción', activity.description),
                        Container(
                          height: 200,
                          child: Image.network(
                            activity.image_path,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  /*Future<Widget> _getImage(BuildContext context, String image) async {
    Image m;
    await FireStorageService.loadFromStorage(context, image).then((downloadUrl) {
      m = Image.network(
        downloadUrl.toString(),
        fit: BoxFit.scaleDown,
      );
    });
    return m;
  }*/

  Widget _detailsItem(String label, String value) {
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
        ));
  }

  _activityName(Activity activity) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(
                      child: ActivityDetailPage(
                          projectID: widget.project.documentID,
                          activityID: activity.documentID),
                      onBackPressed: () => Navigator.of(context).pop(),
                    ))),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 5,
                    offset: Offset(0, 3))
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.name,
                      style: essadeParagraph(color: essadeBlack),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      'Progreso: ${activity.progress}%',
                      style: essadeLightfont(),
                    ),
                    SizedBox(height: 10.0),
                    LinearProgressIndicator(
                      value: activity.progress.toDouble() / 100,
                      backgroundColor: essadeGray,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(essadePrimaryColor),
                    ),
                  ],
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
