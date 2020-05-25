import 'package:ESSADE_Admin/utilities/constants.dart';
import 'package:ESSADE_Admin/widgets/collapsing_list_tile_widget.dart';
import 'package:flutter/material.dart';

class CollapsingNavigationDrawerWidget extends StatefulWidget {
  @override
  _CollapsingNavigationDrawerWidgetState createState() => _CollapsingNavigationDrawerWidgetState();
}

class _CollapsingNavigationDrawerWidgetState extends State<CollapsingNavigationDrawerWidget> with SingleTickerProviderStateMixin{
  double maxWidth = 250;
  double minWidth = 80;
  bool isCollapsed = false;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  int currentSelectedIndex = 0;


  List<NavigationItem> navigationItems = [
    NavigationItem(title: 'Tablero', icon: Icons.dashboard),
    NavigationItem(title: 'Usuarios', icon: Icons.person),
    NavigationItem(title: 'Proyectos', icon: Icons.book),
    NavigationItem(title: 'Actividades', icon: Icons.local_activity),
    NavigationItem(title: 'Movimientos', icon: Icons.attach_money)
  ];


  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget){
        return Container(
          width: widthAnimation.value,
          color: Colors.white,
          child: Column(
            children: [
              _buildCollapsingLogo(),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 30.0),
                  itemBuilder: (context, index){
                    return CollapsingListTileWidget(
                      onTap: (){
                        setState(() {
                          currentSelectedIndex = index;
                        });
                      },
                      isSelected: currentSelectedIndex == index,
                      title: navigationItems[index].title,
                      icon: navigationItems[index].icon,
                      animationController: _animationController,
                    );
                  },
                  itemCount: navigationItems.length,
                ),
              ),
              InkWell(
                onTap: (){
                  setState(() {
                    isCollapsed = !isCollapsed;
                    isCollapsed ? _animationController.reverse() : _animationController.forward();
                  });
                },
                child: AnimatedIcon(
                  icon: AnimatedIcons.close_menu,
                  progress: _animationController,
                  color: essadeDarkGray,
                  size: 30.0,
                ),
              ),
              SizedBox(height: 50.0),
            ],
          ),
        );
      },
    );
  }

  _buildCollapsingLogo(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      child: Row(
        children: [
          Image.asset('assets/logos/essade.png', height: 50),
          (widthAnimation.value >= 220)
              ? Container(margin: EdgeInsets.only(left: 15.0),child: Text('ESSADE', style: essadeH4(essadeGray)))
              : Container()
        ],
      ),
    );
  }
}

class NavigationItem {
  final String title;
  final IconData icon;

  NavigationItem({this.title, this.icon});
}