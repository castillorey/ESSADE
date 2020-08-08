import 'package:essade/models/Movement.dart';
import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class TimelineItemWidget extends StatelessWidget {
  final Movement movement;

  const TimelineItemWidget({Key key, this.movement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = "es";
    initializeDateFormatting();
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: <Widget>[
          _movementDate(movement),
          _movementInfo(context, movement)
        ],
      ),
    );
  }

  Widget _movementDate(Movement movement) {
    var date = DateFormat.yMMMd().format(movement.startDate.toDate());
    return Container(
        width: 55,
        //padding: EdgeInsets.only(left: 8),
        margin: EdgeInsets.only(right: 8.0),
        child: Text(
          date.toString(),
          style: essadeH5(essadeGray),
        ));
  }

  Widget _movementInfo(context, Movement movement) {
    var appropiateColor =
        movement.type == 'Egreso' ? essadeGray : essadePrimaryColor;
    return Expanded(
      child: GestureDetector(
          onTap: () => _showMovementModalBottomSheet(context, movement),
          child: ClipPath(
              clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)))),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                decoration: BoxDecoration(
                    color: appropiateColor.withOpacity(0.15),
                    border: Border(
                        right: BorderSide(color: appropiateColor, width: 3.5))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      movement.name,
                      style:
                          essadeParagraph(color: appropiateColor, bold: true),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      globalCurrencyFormat
                          .format(movement.value)
                          .toString()
                          .replaceAll(',', '.'),
                      style: essadeParagraph(color: appropiateColor),
                    )
                  ],
                ),
              ))),
    );
  }

  Widget _detailsItem(String label, String value) {
    return Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: essadeParagraph(),
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: essadeParagraph(color: essadeGray),
            )
          ],
        ));
  }

  _showMovementModalBottomSheet(context, Movement movement) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          var date =
              DateFormat.MMMd().add_jm().format(movement.startDate.toDate());
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    movement.name,
                    style: essadeH2(essadePrimaryColor),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Detalle de la actividad',
                    style: essadeH4(essadeDarkGray),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        _detailsItem('Fecha de movimiento:', date),
                        _detailsItem('Tipo de Movimiento:', movement.type),
                        _detailsItem('Descripción:', movement.description),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
