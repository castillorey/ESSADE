import 'package:essade/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectableFormFieldWidget extends FormField<List> {

  SelectableFormFieldWidget({
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
    List initialValue = const [],
    bool autovalidate = false,
  }) : super(
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      autovalidate: autovalidate,
      builder: (FormFieldState<List> state) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                        color: essadeGray.withOpacity(0.5),
                        width: 1.0
                    )
                ),
                height: 60.0,
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.work,
                      color: essadeDarkGray,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'services[pickerSelectionConfirmed]',
                      style: essadeParagraph,
                    )
                  ],
                )
            ),
          ],
        );
      }
  );
}