import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

class QuoteCategoryWidget extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;

  const QuoteCategoryWidget(
      {Key key, this.name, this.icon, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _color = isSelected ? essadePrimaryColor : essadeGray;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Column(
        children: [
          Container(
            width: 55.0,
            height: 68.0,
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(width: isSelected ? 3.0 : 1.0, color: _color),
              color: isSelected
                  ? essadePrimaryColor.withOpacity(0.2)
                  : Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Icon(icon, color: _color)],
            ),
          ),
          SizedBox(height: 10.0),
          Text(name, style: essadeLightfont(), textAlign: TextAlign.center)
        ],
      ),
    );
  }
}
