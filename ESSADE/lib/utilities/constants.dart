import 'package:essade/models/Category.dart';
import 'package:essade/models/Value.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

final screenSizeHeight =
    ui.window.physicalSize.height / ui.window.devicePixelRatio;
final screenSizeWidth =
    ui.window.physicalSize.width / ui.window.devicePixelRatio;

essadeTitle(Color color) => TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: color);

essadeH3(Color color) => TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: color);

essadeH2(Color color) => TextStyle(
    color: color,
    fontFamily: 'Montserrat',
    fontSize: 30.0,
    fontWeight: FontWeight.bold);

essadeH4(Color color) => TextStyle(
      color: color,
      fontFamily: 'Raleway',
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    );

essadeH5(Color color) => TextStyle(
      color: color,
      fontFamily: 'Raleway',
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    );

essadeParagraph(
        {Color color = essadeBlack,
        bool bold = false,
        bool underlined = false}) =>
    TextStyle(
      color: color,
      fontFamily: 'Raleway',
      fontSize: 14.0,
      fontWeight: bold ? FontWeight.bold : null,
      decoration: underlined ? TextDecoration.underline : null,
    );

essadeLightfont({bool underlined = false}) => TextStyle(
      color: essadeDarkGray,
      fontFamily: 'Raleway',
      fontSize: 12.0,
      decoration: underlined ? TextDecoration.underline : null,
    );

essadeCustomFont(
    {double fontSize,
    String fontFamily = '',
    Color color = essadeBlack,
    bool underlined = false,
    bool bold = false}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: fontFamily,
    fontWeight: bold ? FontWeight.bold : null,
    decoration: underlined ? TextDecoration.underline : null,
  );
}

final List<String> essadeServices = [
  'Diseño',
  'Construcción',
  'Mantenimiento',
  'Remodelación'
];

final List<Category> quoteCategories = [
  Category('Consultoría', Icons.business_center),
  Category('Diseño', Icons.brush),
  Category('Construcción', Icons.home),
  Category('Remodelación', Icons.pan_tool),
  Category('Mantenimiento', Icons.build),
  Category('Otros', Icons.more_horiz),
];

final String essadeWhoWeAreP1 =
    'ESSADE S.A.S., es una empresa constructora de obras civiles, '
    'comprometida con la excelencia, transparencia y calidad de sus proyectos.';
final String essadeWhoWeAreP2 =
    'Somos personas transformando al país, a través de la formación'
    ' integral de nuestros colaboradores e inspiración a nuestros clientes.';

final String essadeMissionP =
    'Proveer satisfacción a nuestros clientes a través de un servicio exclusivo,'
    ' mano de obra calificada y la construcción eficiente de sus proyectos de obra civil.';

final String essadeVisionP =
    'Transformar la industria de la construcción en Colombia por medio de un'
    ' servicio de calidad, confiable e innovador.';

final List<Value> essadeValues = [
  new Value('Pasión', 'Amamos lo que hacemos', 'assets/values/heart.png'),
  new Value('Integridad', 'Somos diferentes', 'assets/values/integrity.png'),
  new Value('Excelencia', 'No nos conformamos', 'assets/values/excelence.png'),
  new Value('Calidad', 'Nos importa cada detalle', 'assets/values/qa.png'),
  new Value('Liderazgo', 'Vamos un paso adelante', 'assets/values/lead.png'),
  new Value(
      'Trasparencia', 'Generamos confianza', 'assets/values/transparency.png'),
  new Value('Compromiso', 'Planificamos con tus necesidades',
      'assets/values/hands.png'),
  new Value('Servicio', 'Eres nuestra prioridad', 'assets/values/service.png'),
];

final NumberFormat globalCurrencyFormat =
    NumberFormat.simpleCurrency(locale: 'en', decimalDigits: 0);

final Map<String, String> FAQ = {
  '¿Por qué escoger a ESSADE S.A.S.?':
      'Somos la alternativa económica y de calidad en el diseño, construcción, remodelación y mantenimiento de obras civiles. Brindamos un servicio exclusivo, confiable e innovador.',
  '¿Qué servicios ofrecen?':
      'Ofrecemos el servicio de diseño, construcción, remodelación y mantenimiento de obras civiles. Puedes observar nuestro portafolio de servicios en nuestro website o en la sección "Cotizar" de la App.',
  '¿Cuáles son sus promociones?':
      'En el proceso de cotización te brindamos la asesoría, completamente gratis. Síguenos en redes sociales para informarte de nuestras últimas promociones.',
  '¿Cuál es el proceso de cotización? ¿Tiene costo?':
      'Si deseas cotizar con nosotros debes comunicarte con nuestro Director Comercial a la línea +57 300 3938174, agendaremos una visita técnica y luego procederemos a enviarte la cotización. El proceso de cotización es completamente gratuito.',
  '¿Cuánto demora el envío de la cotización?':
      'El envío de la cotización tendrá un período de 1 a 5 días hábiles dependiendo del servicio.',
  'He aceptado su cotización. ¿Cuándo inician los trabajos?':
      'El servicio inicia 2 días hábiles después del pago del anticipo.',
  '¿Cuál es el horario de atención?':
      'Nuestro horario de atención en nuestros canales virtuales y telefónicos es de Lunes a Viernes de 7:00am-12:00pn y 1:00pm-5:00pm, los días sábado de 7:00am-12:00pm.',
  '¿Cómo ESSADE S.A.S se está adaptando al Covid-19?':
      'Tenemos habilitados todas nuestras plataformas digitales para atender a nuestros clientes.\n\n' +
          'Todos nuestros colaboradores cuentan con las medidas de protección y prevención para afrontar la emergencia sanitaria.'
};

launchPortfolio() async {
  const url =
      'https://60609f88-6199-49b0-80e1-3c93c22494fa.filesusr.com/ugd/d8bb6c_507bccd8b9114f3cb9b322ea7b1b0722.pdf';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

btnFontStyle(Color color, {bool bold: false}) => TextStyle(
      color: color,
      letterSpacing: 1.5,
      fontSize: 16.0,
      fontWeight: bold ? FontWeight.bold : null,
      fontFamily: 'Raleway',
    );

essadeBorderErrorStyle(double borderRadius, Color color, {double width: 1.0}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: BorderSide(color: color, width: width),
  );
}

iosFontStyle({bool bold = false, double size = 16}) => TextStyle(
    fontFamily: 'SFProDisplay',
    fontWeight: bold ? FontWeight.bold : null,
    fontSize: size);

androidFontStyle({bool bold = false, double size = 16}) => TextStyle(
    fontFamily: 'Roboto',
    fontWeight: bold ? FontWeight.bold : null,
    fontSize: size);

Future<void> showLoadingProgressCircle(
    BuildContext context, GlobalKey key) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new WillPopScope(
            onWillPop: () async => false,
            child: Center(
              key: key,
              child: CircularProgressIndicator(),
            ));
      });
}

String capitalize(String string) {
  if (string == null) {
    throw ArgumentError("string: $string");
  }

  if (string.isEmpty) {
    return string;
  }

  return string[0].toUpperCase() + string.substring(1);
}

enum PlatformType { iOS, android }
enum DetailPageType {
  Chat,
  TelephoneDirectory,
  FAQ,
  About,
  MisionVision,
  Values,
  Principles,
  Policy
}

enum MainAppPages { SignIn, RegisterId, StepperRegister, Container }
const Color essadePrimaryColor = Color(0xFF82142d);
const Color essadeBlack = Color(0xFF262626);
const Color essadeDarkGray = Color(0xFF85878a);
const Color essadeGray = Color(0xFFa5a5aa);
const Color essadeErrorColor = Color(0xFFED4337);
const Color essadeIncomeColor = Color(0xFF00B894);
const Color essadeOutgoingColor = Color(0xFFD63031);
const Color essadeRedOrangeColor = Color(0xFFFF5349);
