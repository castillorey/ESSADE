import 'package:ESSADE_Admin/utilities/constants.dart';
import 'package:flutter/material.dart';

class CollapsingListTileWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final AnimationController animationController;
  final bool isSelected;
  final Function onTap;

  const CollapsingListTileWidget(
      {Key key,
        this.title,
        this.icon,
        this.animationController,
        this.isSelected = false,
        this.onTap}
      ) : super(key: key);

  @override
  _CollapsingListTileWidgetState createState() => _CollapsingListTileWidgetState();
}

class _CollapsingListTileWidgetState extends State<CollapsingListTileWidget> {
  Animation<double> widthAnimation, sizedBoxAnimation;

  @override
  void initState() {
    super.initState();
    widthAnimation =
        Tween<double>(begin: 250, end: 80).animate(widget.animationController);
    sizedBoxAnimation =
        Tween<double>(begin: 30, end: 0).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          border: widget.isSelected
              ? Border(right: BorderSide(width: 3.0, color: essadePrimaryColor))
              : null,
        ),
        width: widthAnimation.value,
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 25.0),
        child: Row(
          children: [
            Icon(widget.icon, color: widget.isSelected ? essadePrimaryColor : essadeGray, size: 25.0),
            SizedBox(width: sizedBoxAnimation.value),
            (widthAnimation.value >= 220)
                ? Text(widget.title, style: essadeParagraph(color: widget.isSelected ? essadePrimaryColor : essadeGray))
                : Container()
          ],
        ),
      ),
    );
  }
}
