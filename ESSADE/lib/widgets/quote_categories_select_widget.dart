import 'package:essade/models/Category.dart';
import 'package:essade/widgets/quote_category_widget.dart';
import 'package:flutter/material.dart';

class QuoteCategoriesSelectWidget extends StatefulWidget {
  final List<Category> categories;
  final Function(String) onItemSelected;

  const QuoteCategoriesSelectWidget({Key key, this.categories, this.onItemSelected}) : super(key: key);
  @override
  _QuoteCategoriesSelectState createState() => _QuoteCategoriesSelectState();
}

class _QuoteCategoriesSelectState extends State<QuoteCategoriesSelectWidget> {
  String _categorySelected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _categorySelected = '';
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (BuildContext ctx, int index){
          return GestureDetector(
            onTap: () {
              setState(() {
                _categorySelected = widget.categories[index].name;
                widget.onItemSelected(_categorySelected);
              });
            },
            child: QuoteCategoryWidget(
              name: widget.categories[index].name,
              icon: widget.categories[index].icon,
              isSelected: _categorySelected == widget.categories[index].name,
            ),
          );
        },
      ),
    );
  }
}
