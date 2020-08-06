import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/auth/login_state.dart';
import 'package:essade/controllers/projects_repository.dart';
import 'package:essade/models/Subactivity.dart';
import 'package:essade/models/User.dart';
import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ActivityDetailPage extends StatelessWidget {
  final String activityID;
  final String projectID;

  const ActivityDetailPage({Key key, this.activityID, this.projectID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    User _currentUser =
        Provider.of<LoginState>(context, listen: false).currentUser();
    var _subactivitiesQuery = ProjectsRepository(_currentUser.documentID)
        .querySubActivities(projectID, activityID);
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _subactivitiesQuery,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final documents = snapshot.data.documents;
            var subactivities = [];
            documents.forEach((subactivity) {
              subactivities.add(Subactivity.fromSnapshot(subactivity));
            });
            if (subactivities.length == 0) {
              return _buildEmptyActivity();
            } else {
              return Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text('Detalle de actividad',
                        style: essadeH3(essadePrimaryColor)),
                  ),
                  SizedBox(height: 5.0),
                  Divider(
                    indent: screenSizeWidth * 0.05,
                    endIndent: screenSizeWidth * 0.05,
                    thickness: 0.5,
                    color: essadeDarkGray,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: subactivities.length,
                        padding: EdgeInsets.only(
                          top: 20,
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.only(bottom: 15.0),
                              child: _subActivity(subactivities[index]));
                        }),
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

  _subActivity(Subactivity subactivity) {
    var date = DateFormat.MMMd().add_jm().format(subactivity.date.toDate());
    return Container(
      child: Column(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Fecha: ",
                  textAlign: TextAlign.left,
                  style: essadeParagraph(),
                ),
                Text(
                  date,
                  style: essadeParagraph(color: essadeGray),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Descripción:",
                    textAlign: TextAlign.left,
                    style: essadeParagraph(),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    subactivity.description,
                    textAlign: TextAlign.left,
                    style: essadeParagraph(color: essadeGray),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 200,
            width: double.infinity,
            child: Image.network(
              subactivity.imagePath,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.0)
        ],
      ),
    );
  }

  _buildEmptyActivity() {
    return Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Esta actividad aún no comienza',
              textAlign: TextAlign.center,
              style: essadeH3(essadeBlack),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/empty.png',
                  height: screenSizeHeight * 0.3),
            ),
            SizedBox(height: screenSizeHeight * 0.1)
          ],
        ));
  }
}
