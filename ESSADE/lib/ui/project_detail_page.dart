import 'package:essade/models/Project.dart';
import 'package:essade/ui/project_activities_subpage.dart';
import 'package:essade/ui/project_movements_subpage.dart';
import 'package:essade/ui/project_values_subpage.dart';
import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectDetailPage extends StatelessWidget {
  final Project project;

  ProjectDetailPage({Key key, this.project}) : super(key: key);

  PageController controller = PageController(
    initialPage: 0
  );

  Widget _title() {
    return Align(
      child: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              project.name,
              style: essadeH2(essadePrimaryColor),
            ),
            Text(
              '${project.city}, ${project.state}',
              style: essadeH4(essadeBlack),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.close, color: essadeBlack),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          brightness: Brightness.light,
          elevation: 0.0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: <Widget>[
              _title(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PageView(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      ProjectValuesSubpage(project: project),
                      ProjectActivitiesSubpage(project: project),
                      ProjectMovementsSubpage()
                    ],
                  ),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }


}

