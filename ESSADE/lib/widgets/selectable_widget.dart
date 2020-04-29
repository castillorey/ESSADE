import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectableWidget extends StatefulWidget {
  final String objectKey;
  final List<DocumentSnapshot> documents;
  Function isProjectSelectedCallback;

  SelectableWidget({Key key, this.objectKey, this.documents, this.isProjectSelectedCallback}) : super(key: key);

  @override
  _SelectableWidgetState createState() => _SelectableWidgetState();
}

class _SelectableWidgetState extends State<SelectableWidget> {
  String projectSelected;
  int pickerSelection, pickerSelectionConfirmed;


  @override
  void initState() {
    super.initState();
    projectSelected = 'Seleccione un proyecto...';
    pickerSelection = 0;
    pickerSelectionConfirmed = 0;

  }


  Future _myShowCupertinoModalPopup(List<DocumentSnapshot> documents){
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
                      projectSelected = documents[pickerSelectionConfirmed][widget.objectKey];
                      this.widget.isProjectSelectedCallback(true, pickerSelectionConfirmed);
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
                children: documents.map((object){
                  return Container(
                    alignment: Alignment.center,
                    child: Text(object[widget.objectKey]),
                  );
                }).toList()
            ),
          )
        ],
      );
    });
  }

  Widget _buildSelectableComponent(List<DocumentSnapshot> documents){
    Widget selectableWidget;
    if(Platform.isAndroid){
      selectableWidget = DropdownButton(
          value: projectSelected,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          onChanged: (newValue) {
            projectSelected = newValue;
          },
          items: documents.map((project){
            return DropdownMenuItem(
              value: project[widget.objectKey],
              child: Text(project[widget.objectKey]),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                    color: essadeGray.withOpacity(0.2),
                    width: 1.0
                )
            ),
            height: 60.0,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.card_travel,
                  color: essadeDarkGray,
                ),
                SizedBox(width: 10),
                Text(
                  projectSelected,
                  style: essadeParagraph(),
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

