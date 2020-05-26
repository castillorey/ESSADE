import 'package:ESSADE_Admin/ui/activities_page.dart';
import 'package:ESSADE_Admin/ui/dashboard_page.dart';
import 'package:ESSADE_Admin/ui/movements_page.dart';
import 'package:ESSADE_Admin/ui/projects_page.dart';
import 'package:ESSADE_Admin/ui/users_page.dart';
import 'package:ESSADE_Admin/utilities/constants.dart';
import 'package:ESSADE_Admin/widgets/collapsing_navigation_drawer_widget.dart';
import 'package:ESSADE_Admin/widgets/simple_navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'models/NavigationItem.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'ESSADE Admin'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);



  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>  with SingleTickerProviderStateMixin{
  int _selectedPage = 0;
  bool _isCollapsed = false;

  List<Widget> _pageList = [
    DashboardPage(),
    UsersPage(),
    ProjectsPage(),
    ActivitiesPage(),
    MovementsPage(),
  ];

  List<NavigationItem> _navigationItems = [
    NavigationItem(title: 'Tablero', icon: Icons.dashboard),
    NavigationItem(title: 'Usuarios', icon: Icons.person),
    NavigationItem(title: 'Proyectos', icon: Icons.book),
    NavigationItem(title: 'Actividades', icon: Icons.local_activity),
    NavigationItem(title: 'Movimientos', icon: Icons.attach_money)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }
  
  void _onMenuCollapsed(bool isCollapsed){
    setState(() {
      _isCollapsed = isCollapsed;
    });
  }
  AnimationController _animationController;
  Animation<double> widthAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: sideMenuMaxWidth, end: sideMenuMaxWidth).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {

    return ResponsiveBuilder(
      builder: (context, sizingInformation){
        return sizingInformation.deviceScreenType == DeviceScreenType.mobile
            ? _buildMobileView()
            : _buildDesktopAndTabletView();
      },
    );
  }

  _buildMobileView(){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: essadeAdminBackground,
        elevation: 0.0,
        iconTheme: IconThemeData(color: essadeBlack),
      ),
      drawer: SimpleNavigationDrawerWidget(
        onItemSelected: (item) {
          _onItemTapped(item);
        },
        navigationItems: _navigationItems,
      ),
      body: IndexedStack(
        index: _selectedPage,
        children: _pageList,
      ),
    );
  }

  _buildDesktopAndTabletView(){
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              top: 0,
              left: _isCollapsed ? sideMenuMinWidth : sideMenuMaxWidth,
              height: MediaQuery.of(context).size.height,
              width: _isCollapsed ? screenWidth - sideMenuMinWidth : screenWidth - sideMenuMaxWidth,
              child: IndexedStack(
                index: _selectedPage,
                children: _pageList,
              )
          ),
          /*,*/
          Positioned(
            left: 0,
            height: MediaQuery.of(context).size.height,
            child: CollapsingNavigationDrawerWidget(
              navigationItems: _navigationItems,
              onItemSelected: (item) {
                _onItemTapped(item);
              },
              onMenuCollapsed: (isCollapsed) => _onMenuCollapsed(isCollapsed),
            ),
          )
        ],
      ),
    );
  }
}
