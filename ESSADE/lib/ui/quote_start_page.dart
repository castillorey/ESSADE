import 'package:essade/auth/login_state.dart';
import 'package:essade/models/User.dart';
import 'package:essade/models/Value.dart';
import 'package:essade/ui/stepper_quote_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/long_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'detail_page.dart';

class QuoteStartPage extends StatefulWidget {
  @override
  _QuoteStartPageState createState() => _QuoteStartPageState();
}

class _QuoteStartPageState extends State<QuoteStartPage> {
  bool _notShowChecked;
  User _currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _notShowChecked = false;
    _currentUser =
        Provider.of<LoginState>(context, listen: false).currentUser();
  }

  @override
  Widget build(BuildContext context) {
    final _shouldDisplayQuote = Provider.of<LoginState>(context, listen: false)
        .shouldDisplayGuestQuote();
    return DetailPage(
        onBackPressed: null,
        child: Consumer<LoginState>(
          builder: (BuildContext context, LoginState value, Widget child) {
            if (value.isLoading()) {
              return Container(
                  color: Colors.white,
                  child: Center(child: CircularProgressIndicator()));
            } else {
              return child;
            }
          },
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      '¡Hola!, Mi nombre es Lucho, un gusto saludarte. ' +
                          'Yo te acompañaré en tu proceso de cotización.',
                      style: essadeH4(essadeBlack),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset('assets/images/lucho.png',
                          height: screenSizeHeight * 0.35)),
                  SizedBox(height: 10.0),
                  LongButtonWidget(
                    textColor: Colors.white,
                    backgroundColor: essadePrimaryColor,
                    text: 'Comenzar',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(
                                    child: StepperQuotePage(
                                        notShowAgain: _notShowChecked),
                                    onBackPressed: () =>
                                        Navigator.of(context).pop(),
                                  )));
                    },
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () => Provider.of<LoginState>(context, listen: false)
                        .notifyGuestQuoteDisplayed(
                            notShowAgain: _notShowChecked),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Saltar',
                        style: essadeParagraph(underlined: true),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Align(
                            alignment: _shouldDisplayQuote
                                ? Alignment.centerLeft
                                : Alignment.center,
                            child: GestureDetector(
                                onTap: () => launchPortfolio(),
                                child: Text('Conoce nuestro portafolio',
                                    style: essadeParagraph(
                                        color: essadePrimaryColor,
                                        underlined: true)))),
                      ),
                      Visibility(
                        visible: _shouldDisplayQuote,
                        child: Expanded(
                          child: Row(children: [
                            Checkbox(
                              value: _notShowChecked,
                              onChanged: (value) {
                                setState(() {
                                  _notShowChecked = value;
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                'No volver a mostrar',
                                style: essadeParagraph(),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ));
  }
}
