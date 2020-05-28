import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectableWidget extends StatefulWidget {
  final String objectKey;
  final String initialText;
  final List documents;
  final IconData icon;
  final borderColor;
  final Color textColor;

  final Function(int) onItemSelected;

  SelectableWidget({
    Key key,
    this.objectKey,
    this.documents,
    this.initialText,
    this.icon,
    this.onItemSelected,
    this.borderColor,
    this.textColor = essadeBlack
  }) : super(key: key);

  @override
  _SelectableWidgetState createState() => _SelectableWidgetState();
}

class _SelectableWidgetState extends State<SelectableWidget> {
  String itemSelected;
  int pickerSelection, pickerSelectionConfirmed;


  @override
  void initState() {
    super.initState();
    itemSelected = widget.initialText;
    pickerSelection = 0;
    pickerSelectionConfirmed = 0;

  }


  Future _myShowCupertinoModalPopup(List documents){
    pickerSelection = pickerSelectionConfirmed;
    return showCupertinoModalPopup(context: context, builder: (context){
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Color(0xff999999),
                  width: 0.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CupertinoButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    setState(() {
                      pickerSelection = pickerSelectionConfirmed;
                    });
                    Navigator.of(context).pop();
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 5.0,
                  ),
                ),
                CupertinoButton(
                  child: Text('Hecho'),
                  onPressed: () {
                    setState(() {
                      pickerSelectionConfirmed = pickerSelection;
                      widget.onItemSelected(pickerSelectionConfirmed);
                      itemSelected = documents[pickerSelectionConfirmed];
                    });
                    Navigator.of(context).pop();
                  },
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 5.0,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 320.0,
            color: Color(0xfff7f7f7),
            child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: pickerSelectionConfirmed),
                onSelectedItemChanged: (val) {
                  setState(() {
                    pickerSelection = val;
                  });
                },
                useMagnifier: true,
                magnification: 1.2,
                itemExtent: 30,
                children: documents.map((value){
                  return Container(
                    alignment: Alignment.center,
                    child: Text(value),
                  );
                }).toList()
            ),
          )
        ],
      );
    });
  }

  Widget _buildSelectableComponent(List documents){
    Widget selectableWidget;
    if(Platform.isAndroid){
      selectableWidget = DropdownButton(
          value: itemSelected,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          onChanged: (newValue) {
            itemSelected = newValue;
          },
          items: documents.map((value){
            return DropdownMenuItem(
              value: value,
              child: Text(value),
            );
          }).toList()
      );
    } else if (Platform.isIOS){
      selectableWidget = GestureDetector(
        onTap: () => _myShowCupertinoModalPopup(documents),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                    color: widget.borderColor,
                    width: 1.0
                )
            ),
            height: 60.0,
            child: Row(
              children: <Widget>[
                if (widget.icon != null)
                  Icon(
                    widget.icon,
                    color: essadeDarkGray,
                  ),
                  SizedBox(width: 10),
                Text(
                  itemSelected,
                  style: essadeParagraph(color: widget.textColor),
                )
              ],
            )
        ),
      );
    }
    return selectableWidget;
  }

  @override
  Widget build(BuildContext context) {
    return _buildSelectableComponent(widget.documents);
  }
}

