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

  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue, //or set color with: Color(0xFF0000FF)
    ));
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
        body: PageView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            ProjectValuesSubpage(),
            ProjectActivitiesSubpage(),
            ProjectMovementsSubpage()
          ],
        ),
      ),
    );
  }


}

