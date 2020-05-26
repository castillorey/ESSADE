import 'package:ESSADE_Admin/models/NavigationItem.dart';
import 'package:ESSADE_Admin/utilities/constants.dart';
import 'package:ESSADE_Admin/widgets/simple_list_tile_widget.dart';
import 'package:flutter/material.dart';

class SimpleNavigationDrawerWidget extends StatefulWidget {
  final Function(int) onItemSelected;
  final List<NavigationItem> navigationItems;

  const SimpleNavigationDrawerWidget({Key key, this.onItemSelected, this.navigationItems}) : super(key: key);

  @override
  _SimpleNavigationDrawerWidgetState createState() => _SimpleNavigationDrawerWidgetState();
}

class _SimpleNavigationDrawerWidgetState extends State<SimpleNavigationDrawerWidget> {
  int currentSelectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      currentSelectedIndex = index;
      widget.onItemSelected(index);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0.5,
      child: Container(
        width: sideMenuMaxWidth,
        color: Colors.white,
        child: Column(
          children: [
            _buildLogo(),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 30.0),
                itemBuilder: (context, index){
                  return SimpleListTileWidget(
                    onTap: (){
                      _onItemTapped(index);
                    },
                    isSelected: currentSelectedIndex == index,
                    title: widget.navigationItems[index].title,
                    icon: widget.navigationItems[index].icon,
                  );
                },
                itemCount: widget.navigationItems.length,
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.close,
                color: essadeDarkGray,
                size: 30.0,
              ),
            ),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }

  _buildLogo(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      child: Row(
        children: [
          Image.asset('assets/logos/essade.png', height: 50),
          Container(margin: EdgeInsets.only(left: 15.0),child: Text('ESSADE', style: essadeH4(essadeGray)))
        ],
      ),
    );
  }
}
