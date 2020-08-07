import 'dart:io';

import 'package:essade/auth/login_state.dart';
import 'package:essade/models/Category.dart';
import 'package:essade/models/User.dart';
import 'package:essade/ui/how_to_contact_page.dart';
import 'package:essade/widgets/long_button_widget.dart';
import 'package:essade/widgets/quote_categories_select_widget.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/card_item_widget.dart';
import 'package:essade/widgets/simple_text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:provider/provider.dart';
import 'detail_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/smtp_server.dart';

class StepperQuotePage extends StatefulWidget {
  final bool notShowAgain;

  const StepperQuotePage({Key key, this.notShowAgain}) : super(key: key);
  @override
  _StepperQuotePageState createState() => _StepperQuotePageState();
}

class _StepperQuotePageState extends State<StepperQuotePage> {
  PageController formsPageViewController = PageController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController nameInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  User currentUser;
  List _formSteps = [];
  String _description;
  String _categorySelected = '';
  int _currentPageValue;
  bool _nonCategorySelected = false;
  File _image;
  final picker = ImagePicker();
  File imageFile;
  String _userName;
  String _userEmail;

  @override
  void initState() {
    super.initState();

    currentUser = Provider.of<LoginState>(context, listen: false).currentUser();
    _formSteps = [
      if (currentUser == null)
        WillPopScope(
          onWillPop: () => Future.sync(this.onWillPop),
          child: _buildGuestStep(context),
        ),
      WillPopScope(
        onWillPop: () => Future.sync(this.onWillPop),
        child: _buildStepOne(context),
      ),
      WillPopScope(
        onWillPop: () => Future.sync(this.onWillPop),
        child: _buildStepTwo(context),
      )
    ];
    _description = '';
    _userName = currentUser != null ? currentUser.name : 'Invitado';
    _userEmail = currentUser != null ? currentUser.email : 'Invitado';
    _currentPageValue = 0;

    print(
        'Starting _description: $_description, _guestName: $_userName, _guestEmail: $_userEmail');
  }

  void _nextFormStep() {
    formsPageViewController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void getChangedPage(int page) {
    setState(() {
      _currentPageValue = page;
    });
  }

  bool onWillPop() {
    if (formsPageViewController.page.round() ==
        formsPageViewController.initialPage) return true;

    formsPageViewController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    return false;
  }

  Future<PickedFile> _getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
        return pickedFile;
      }

      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> sendEmail(String userName, String userEmail, String category,
      String description, File image, String response) async {
    String username = 'noreply.essade@gmail.com';
    String password = 'essade2020';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username)
      ..recipients.add('gerencia.essade@gmail.com')
      ..recipients.add('castilloreyeskm@gmail.com')
      //..ccRecipients.addAll(['castilloreyeskm@gmail.com'])
      //..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject =
          'Nueva Cotización - ${DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now())}'
      ..html = "<h4>Nombre cotizante:</h4>\n" +
          "<p>$userName</p>\n" +
          "<h4>Correo cliente:</h4>\n" +
          "<p>$userEmail</p>\n" +
          "<h4>Categoria a cotizar:</h4>\n" +
          "<p>$category</p>\n" +
          "<h4>Descripción:</h4>\n" +
          "<p>$description</p>\n" +
          "<h4>¿Cómo desea comunicarse?</h4>\n" +
          "<p>$response</p>\n";

    if (image != null) message.attachments.add(FileAttachment(image));

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' +
          sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      print('Message not sent. \n' +
          e.toString()); //print if the email is not sent
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0, left: 15.0),
      child: _buildBody(),
    );
  }

  _buildBody() {
    double topBarHeight = 96.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height - topBarHeight,
          child: PageView.builder(
            controller: formsPageViewController,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return _formSteps[index];
            },
            onPageChanged: (int page) {
              getChangedPage(page);
            },
          ),
        ),
      ],
    );
  }

  _buildGuestStep(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                //width: MediaQuery.of(context).size.width / 1.5,
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Empecemos con tus datos personales',
                        style: essadeCustomFont(
                            fontSize: 23.0,
                            fontFamily: 'Raleway',
                            bold: true,
                            color: essadeBlack),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: essadeGray),
                          borderRadius: BorderRadius.circular(50.0)),
                      child: Image.asset('assets/images/lucho.png',
                          height: screenSizeHeight * 0.1),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              SimpleTextFormFieldWidget(
                label: '¿Cuál es su nombre?',
                inputType: TextInputType.text,
                editingController: nameInputController,
                onChanged: () => _formKey.currentState.validate(),
                validationText: 'Ingrese su nombre',
                hintText: 'Su nombre',
              ),
              SizedBox(height: 5.0),
              SimpleTextFormFieldWidget(
                label: 'Correo electrónico',
                inputType: TextInputType.emailAddress,
                editingController: emailInputController,
                onChanged: () => _formKey.currentState.validate(),
                validationText: 'Ingrese su correo electrónico',
                hintText: 'Su correo electrónico',
              ),
              SizedBox(height: 20.0),
              LongButtonWidget(
                  text: 'Siguiente',
                  icon: null,
                  backgroundColor: essadePrimaryColor,
                  textColor: Colors.white,
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        _userName = nameInputController.text + ' (Invitado)';
                        _userEmail = emailInputController.text;
                      });
                      _nextFormStep();
                    }
                  })
            ],
          ),
        ),
      );
    });
  }

  _buildStepOne(BuildContext context) {
    List<Category> _categories = quoteCategories;
    final _formKey = GlobalKey<FormState>();
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '¿Qué te interesa cotizar?',
                                style: essadeH4(essadeBlack),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20.0),
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1.0, color: essadeGray),
                                  borderRadius: BorderRadius.circular(50.0)),
                              child: Image.asset('assets/images/lucho.png',
                                  height: screenSizeHeight * 0.1),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        Container(
                            height: 120.0,
                            child: QuoteCategoriesSelectWidget(
                              categories: _categories,
                              onItemSelected: (item) {
                                setState(() {
                                  _categorySelected = item;
                                  _nonCategorySelected = false;
                                });
                              },
                            )),
                        Visibility(
                          visible: _nonCategorySelected,
                          child: _buildNonCategorySelected(),
                        ),
                        Divider(
                            thickness: 1.0, color: essadeGray.withOpacity(0.3)),
                        SizedBox(height: 10.0),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Agregar imagen (Opcional)',
                                style: essadeH5(essadeBlack),
                              ),
                              SizedBox(height: 10.0),
                              GestureDetector(
                                onTap: () async {
                                  PickedFile result = await _getImage();
                                  if (result != null) {
                                    setState(() {
                                      _image = File(result.path);
                                      print("Image Picked: $_image");
                                    });
                                  }
                                },
                                child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minHeight: 80.0, maxHeight: 200.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.0,
                                              color:
                                                  essadeGray.withOpacity(0.5)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      child: _image == null
                                          ? Icon(FontAwesomeIcons.fileImage,
                                              color: essadeDarkGray)
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image.file(
                                                _image,
                                                fit: BoxFit.fitWidth,
                                              )),
                                    )),
                              )
                            ],
                          ),
                        ),
                        SimpleTextFormFieldWidget(
                          label: 'Descripción',
                          inputType: TextInputType.text,
                          editingController: descriptionController,
                          onChanged: () => _formKey.currentState.validate(),
                          validationText: 'Debe agregar una descripción',
                          hintText: 'Escriba la descripción',
                          maxLines: 10,
                        ),
                        SizedBox(height: 80.0),
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                  child: Container(
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 20.0),
                child: _buildControlButton(() {
                  FocusScope.of(context).unfocus();
                  if (_categorySelected == '') {
                    setState(() {
                      _nonCategorySelected = true;
                    });
                  }
                  if (_formKey.currentState.validate() &&
                      _categorySelected != '') {
                    setState(() {
                      _description = descriptionController.text;
                    });
                    _nextFormStep();
                  }
                }, "Siguiente"),
              ))
            ],
          ),
        ),
      );
    });
  }

  _buildStepTwo(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            '¿De qué forma deseas que nos contactemos?',
            style: essadeH4(essadeBlack),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/lucho.png',
                height: screenSizeHeight * 0.25)),
        SizedBox(height: 20.0),
        CardItemWidget(
            text: 'Te llamamos',
            icon: FontAwesomeIcons.phone,
            iconColor: essadeDarkGray,
            iconSize: 25,
            onTap: () {
              sendEmail(_userName, _userEmail, _categorySelected, _description,
                  imageFile, 'Por LLamada');
              if (widget.notShowAgain)
                Provider.of<LoginState>(context, listen: false)
                    .disableGuestQuote();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(
                            child: HowToContactPage(
                              text: 'Presta atención a tu teléfono, '
                                  'dentro de poco nos comunicaremos contigo.',
                            ),
                            onBackPressed: () => Navigator.of(context)
                                .popUntil((route) => route.isFirst),
                          )),
                  ModalRoute.withName('/'));
            }),
        SizedBox(height: 20),
        CardItemWidget(
            text: 'Por correo',
            icon: FontAwesomeIcons.envelopeOpen,
            iconColor: essadeDarkGray,
            iconSize: 25,
            onTap: () {
              sendEmail(_userName, _userEmail, _categorySelected, _description,
                  imageFile, 'Por correo');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(
                            child: HowToContactPage(
                              text: 'Presta atención a tu correo, '
                                  'dentro de poco te estaremos enviando una respuesta.',
                            ),
                            onBackPressed: () => Navigator.of(context)
                                .popUntil((route) => route.isFirst),
                          )),
                  ModalRoute.withName('/'));
            }),
        SizedBox(height: 20),
        CardItemWidget(
            text: 'Nos llamas',
            icon: FontAwesomeIcons.headset,
            iconColor: essadeDarkGray,
            iconSize: 25,
            onTap: () {
              sendEmail(_userName, _userEmail, _categorySelected, _description,
                  imageFile, 'Llama cuando pueda');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailPage(
                            child: HowToContactPage(
                              text: 'Puedes contactarnos a las siguientes'
                                  ' lineas:',
                              extra: _buildCallUsAt('(+57) 300 393 8174'),
                            ),
                            onBackPressed: () => Navigator.of(context)
                                .popUntil((route) => route.isFirst),
                          )),
                  ModalRoute.withName('/'));
            }),
      ],
    ));
  }

  _buildControlButton(Function onPressed, String text, {bool isLarge = false}) {
    return SizedBox(
      width: screenSizeWidth - 120,
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

  _buildNonCategorySelected() {
    return Container(
        padding: const EdgeInsets.only(left: 15.0),
        child: Text("Debe seleccionar una categoría",
            style: essadeCustomFont(fontSize: 12.0, color: essadeErrorColor)));
  }

  _buildCallUsAt(String phone) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.phone,
            color: essadePrimaryColor,
          ),
          SizedBox(width: 20),
          Text(
            '$phone',
            style: essadeH4(essadeGray),
          ),
        ],
      ),
    );
  }
}
