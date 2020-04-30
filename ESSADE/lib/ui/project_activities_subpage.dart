import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/models/Activity.dart';
import 'package:essade/models/Project.dart';
import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text('Actividades', style: essadeH4(essadeDarkGray)),
          ),
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
                  padding: EdgeInsets.only(top: 20),
                  itemBuilder: (context, index){
                    return Padding(
                      padding: EdgeInsets.only(bottom: 50.0),
                      child: Row(
                        children: <Widget>[
                          _activityBadge(),
                          _activityTime(),
                          _activityName(activities[index])
                        ],
                      ),
                    );
                  }
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
      ],
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

  Widget _activityTime(){
    return Container(
        width: 100,
        padding: EdgeInsets.only(left: 8),
        child: Text('8:00 pm')
    );
  }

  Widget _activityName(Activity activity){
    return Expanded(
      child: GestureDetector(
        onTap: () => print(activity.toString()),
        child: Container(
          width: 150,
          height: 60,
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
          child: Text(
            activity.name,
            style: essadeParagraph(color: essadeBlack),
          ),
        ),
      ),
    );
  }
}

