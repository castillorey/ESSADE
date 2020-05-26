import 'package:ESSADE_Admin/utilities/constants.dart';
import 'package:flutter/material.dart';

class SimpleListTileWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final Function onTap;

  const SimpleListTileWidget({
    Key key,
    this.title,
    this.icon,
    this.isSelected,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: isSelected
              ? Border(right: BorderSide(width: 3.0, color: essadePrimaryColor))
              : null,
        ),
        width: sideMenuMaxWidth,
        padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 25.0),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? essadePrimaryColor : essadeGray, size: 25.0),
            SizedBox(width: 15.0),
            Text(title, style: essadeParagraph(color: isSelected ? essadePrimaryColor : essadeGray))
          ],
        ),
      ),
    );
  }
}
