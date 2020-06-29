import 'package:essade/models/Project.dart';
import 'package:essade/ui/project_activities_graph_subpage.dart';
import 'package:essade/ui/project_activities_subpage.dart';
import 'package:essade/ui/project_movements_subpage.dart';
import 'package:essade/ui/project_values_subpage.dart';
import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProjectDetailPage extends StatefulWidget {
  final Project project;

  ProjectDetailPage({Key key, this.project}) : super(key: key);

  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  PageController controller = PageController(
    initialPage: 0,
  );
  int currentPageValue;

  @override
  void initState() {
    super.initState();
    currentPageValue = 0;
  }

  void getChangedPageAndMoveBar(int page) {
    setState(() {
      currentPageValue = page;
    });
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
          padding: EdgeInsets.only(bottom: 15.0, left: 30.0, right: 30.0),
          child: Column(
              children: <Widget>[
                _title(),
                Expanded(
                  child: Container(
                    //padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                        Container(
                          margin:const EdgeInsets.only(top: 10.0, bottom: 30.0),
                          child: PageView.builder(
                            physics: ClampingScrollPhysics(),
                            itemCount: pagesWidgetList().length,
                            controller: controller,
                            scrollDirection: Axis.horizontal,
                            onPageChanged: (int page){
                              getChangedPageAndMoveBar(page);
                            },
                            itemBuilder: (context, index){
                              return pagesWidgetList()[index];
                            },
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.topStart,
                          children: <Widget>[
                            Container(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  for (int i = 0; i < pagesWidgetList().length; i++)
                                    if (i == currentPageValue) ...[circleBar(true)] else
                                      circleBar(false),
                                ],
                              ),
                            ),
                          ],
                        ),
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


  Widget _title() {
    return Align(
      child: Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.project.name,
              style: essadeH2(essadePrimaryColor),
            ),
            Text(
              '${widget.project.city}, ${widget.project.state}',
              style: essadeH4(essadeBlack),
            ),
          ],
        ),
      ),
    );
  }

  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive ? essadePrimaryColor : essadeDarkGray,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }

  List<Widget> pagesWidgetList() => <Widget>[

    Container(
        margin: EdgeInsets.symmetric( horizontal: 10.0),
        child: ProjectActivitiesGraphSubpage(project: widget.project)
    ),
    Container(
      margin: EdgeInsets.symmetric( horizontal: 10.0),
      child: ProjectActivitiesSubpage(project: widget.project)
    ),
    Container(
        margin: EdgeInsets.symmetric( horizontal: 10.0),
        child: ProjectValuesSubpage(project: widget.project)
    ),
    Container(
        margin: EdgeInsets.symmetric( horizontal: 10.0),
        child: ProjectMovementsSubpage(project: widget.project)
    )

  ];
}

