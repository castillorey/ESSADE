import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/models/Activity.dart';
import 'package:essade/models/Project.dart';
import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProjectActivitiesSubpage extends StatefulWidget {
  final Project project;

  const ProjectActivitiesSubpage({Key key, this.project}) : super(key: key);

  @override
  _ProjectActivitiesSubpageState createState() => _ProjectActivitiesSubpageState();
}

class _ProjectActivitiesSubpageState extends State<ProjectActivitiesSubpage> {
  Stream<QuerySnapshot> _activitiesQuery;
  List<Activity> activities;
  
  @override
  void initState() {
    super.initState();
    _activitiesQuery = Firestore.instance
        .collection('actividades')
        .where('id_proyecto', isEqualTo: widget.project.id).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text('Actividades', style: essadeH4(essadeDarkGray)),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _activitiesQuery,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasData){
              final documents = snapshot.data.documents;
              activities = [];
              documents.forEach((activity){
                activities.add(Activity.fromSnapshot(activity));
              });
              return Expanded(
                child: ListView.builder(
                  itemCount: activities.length,
                  padding: EdgeInsets.only(top: 20, left: 5, right: 5),
                  itemBuilder: (context, index){
                    return Padding(
                      padding: EdgeInsets.only(bottom: 50.0),
                      child: Row(
                        children: <Widget>[
                          _activityBadge(),
                          _activityDate(activities[index]),
                          _activityName(activities[index])
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

  _showActivityModalBottomSheet(context, Activity activity){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          var date = DateFormat.yMMMd('en_US').format(activity.start_date.toDate());
          return Container(
            height: MediaQuery.of(context).size.height,
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
                    activity.name,
                    style: essadeH2(essadePrimaryColor),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Detalle de la actividad',
                    style: essadeH4(essadeDarkGray),
                  ),
                  SizedBox(height: 20),
                  _detailsItem('Fecha de actividad', date),
                  _detailsItem('Descripción', activity.description),
                  Expanded(
                    child: Placeholder(),
                  )
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

  Widget _activityBadge(){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0,1),
                color: Color(0x20000000),
                blurRadius: 5
            )
          ]
      ),
      child: Icon(
        Icons.fiber_manual_record,
        size: 20,
        color: essadePrimaryColor,
      ),
    );
  }

  Widget _activityDate(Activity activity){
    var date = DateFormat.yMMMd('en_US').format(activity.start_date.toDate());
    return Container(
        width: 100,
        padding: EdgeInsets.only(left: 8),
        child: Text(date.toString(), style: essadeLightfont,)
    );
  }

  Widget _activityName(Activity activity){
    return Expanded(
      child: GestureDetector(
        onTap: () => _showActivityModalBottomSheet(context, activity),
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
                  activity.name,
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

