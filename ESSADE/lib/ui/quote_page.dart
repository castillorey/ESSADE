import 'package:essade/models/global.dart';
import 'package:essade/ui/stepper_quote_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/quote_form_widget.dart';
import 'package:flutter/material.dart';

import 'detail_page.dart';

class QuotePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, right: 30.0, left: 30.0),
          child: _buildQuoteStartPage(context),
        )
    );
  }

  _buildQuoteStartPage(BuildContext context){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Hola mi nombre es Lucho, un gusto saludarte. '
                    'Yo te acompañaré en tu proceso de cotización',
                style: essadeH4(essadeBlack),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset('assets/images/lucho.png', height: screenSizeHeight * 0.35)
            ),
            SizedBox(height: 20.0),
            _buildLargeButton(
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailPage(
                            child: StepperQuotePage(),
                            onBackPressed: () => Navigator.of(context).pop(),
                          )
                      )
                  );
                },
                "Comenzar"
            )
          ],
        )
    );
  }

  _buildLargeButton(Function onPressed, String text){
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: onPressed,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        color: essadePrimaryColor,
        child: Text(
          text,
          style: essadeH4(Colors.white),
        ),
      ),
    );
  }
}
