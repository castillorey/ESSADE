import 'package:ESSADE_Admin/models/NavigationItem.dart';
import 'package:ESSADE_Admin/utilities/constants.dart';
import 'package:ESSADE_Admin/widgets/collapsing_list_tile_widget.dart';
import 'package:flutter/material.dart';

class CollapsingNavigationDrawerWidget extends StatefulWidget {
  final Function(int) onItemSelected;
  final Function(bool) onMenuCollapsed;
  final List<NavigationItem> navigationItems;

  CollapsingNavigationDrawerWidget({
    Key key,
    this.onItemSelected,
    this.onMenuCollapsed,
    this.navigationItems
  }) : super(key: key);

  @override
  _CollapsingNavigationDrawerWidgetState createState() => _CollapsingNavigationDrawerWidgetState();
}

class _CollapsingNavigationDrawerWidgetState extends State<CollapsingNavigationDrawerWidget> with SingleTickerProviderStateMixin{
  bool isCollapsed = false;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  int currentSelectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      currentSelectedIndex = index;
      widget.onItemSelected(index);
    });
  }

  void _onMenuCollapsed(){
    setState(() {
      widget.onMenuCollapsed(!isCollapsed);
      isCollapsed ? _animationController.reverse() : _animationController.forward();
      isCollapsed = !isCollapsed;
    });
  }
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: sideMenuMaxWidth, end: sideMenuMinWidth).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    var items = widget.navigationItems;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, widget){
        return Material(
          elevation: 0.5,
          child: Container(
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
                          _onItemTapped(index);
                        },
                        isSelected: currentSelectedIndex == index,
                        title: items[index].title,
                        icon: items[index].icon,
                        animationController: _animationController,
                      );
                    },
                    itemCount: items.length,
                  ),
                ),
                InkWell(
                  onTap: (){
                    _onMenuCollapsed();
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
          (widthAnimation.value >= (sideMenuMaxWidth - 12))
              ? Container(margin: EdgeInsets.only(left: 15.0),child: Text('ESSADE', style: essadeH4(essadeGray)))
              : Container()
        ],
      ),
    );
  }
}