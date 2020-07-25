import 'dart:io';

import 'package:essade/models/Category.dart';
import 'package:essade/ui/how_to_contact_page.dart';
import 'package:essade/widgets/quote_categories_select_widget.dart';
import 'package:essade/ui/tel_directory_detail_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/card_item_widget.dart';
import 'package:essade/widgets/simple_text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mailer/mailer.dart';
import 'detail_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mailer/smtp_server.dart';

class StepperQuotePage extends StatefulWidget {
  @override
  _StepperQuotePageState createState() => _StepperQuotePageState();
}

class _StepperQuotePageState extends State<StepperQuotePage> {
  PageController formsPageViewController = PageController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  List _formSteps = [];
  String _description;
  String _categorySelected = '';
  int _currentPageValue;
  bool _nonCategorySelected = false;
  File _image;
  final picker = ImagePicker();
  List<String> attachments = [];
  bool isHTML = false;

  final GlobalKey<ScaffoldState> _keyLoader = new GlobalKey<ScaffoldState>();

  sendEmail() async {
    String username = 'castilloreyeskm@gmail.com';
    String password = '';

    final smtpServer = gmail(username, password);
    // Creating the Gmail server

    // Create our email message.
    final message = Message()
      ..from = Address(username)
      ..recipients.add('dest@example.com') //recipent email
      ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com']) //cc Recipents emails
      ..bccRecipients.add(Address('bccAddress@example.com')) //bcc Recipents emails
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}' //subject of the email
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'; //body of the email

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString()); //print if the email is sent
    } on MailerException catch (e) {
      print('Message not sent. \n'+ e.toString()); //print if the email is not sent
      // e.toString() will show why the email is not sending
    }
  }


  void _nextFormStep() {
    formsPageViewController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _previousFormStep(){
    formsPageViewController.previousPage(
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formSteps = [
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
    _currentPageValue = 0;

  }

  Future<PickedFile> _getImage() async {
    try {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if(pickedFile != null){
        setState(() {
          attachments.add(pickedFile.path);
        });
        return pickedFile;
      }


      return null;
    } catch (error){
      print (error);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0, left: 15.0),
      child: _buildBody(),
    );
  }

  _buildBody(){
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
            onPageChanged: (int page){
              getChangedPage(page);
            },
          ),
        ),
      ],
    );
  }

  _buildStepOne(BuildContext context){
    List<Category> _categories = quoteCategories;
    final _formKey = GlobalKey<FormState>();
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState){
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
                                  '¿En qué estás interesado en cotizar?',
                                  style: essadeH4(essadeBlack),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 20.0),
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1.0, color: essadeGray),
                                    borderRadius: BorderRadius.circular(50.0)
                                ),
                                child: Image.asset('assets/images/lucho.png', height: screenSizeHeight * 0.1),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            height: 120.0,
                            child: QuoteCategoriesSelectWidget(
                              categories: _categories,
                              onItemSelected: (item){
                                setState(() {
                                  _categorySelected = item;
                                  _nonCategorySelected = false;
                                  print("Category selected: $_categorySelected");
                                });
                              },
                            )
                          ),
                          Visibility(
                            visible: _nonCategorySelected,
                            child: _buildNonCategorySelected(),
                          ),
                          Divider(thickness: 1.0, color: essadeGray.withOpacity(0.3)),
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
                                     if (result != null){
                                       setState(() {
                                         _image = File(result.path);
                                         print("Image Picked: $_image");
                                       });
                                     }
                                  },
                                  child: Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1.0, color: essadeGray.withOpacity(0.5)),
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      ),
                                      child: _image == null ?
                                      Icon(FontAwesomeIcons.fileImage, color: essadeDarkGray) :
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child: Image.file(_image, fit: BoxFit.fitWidth,))
                                  ),
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
                  bottom: 10.0,
                  child: _buildControlButton(() {
                    FocusScope.of(context).unfocus();
                    if(_categorySelected == ''){
                      setState(() {
                        _nonCategorySelected = true;
                      });
                    }
                    if(_formKey.currentState.validate() && _categorySelected != ''){
                      setState(() {
                        _description = descriptionController.text;
                      });
                      _nextFormStep();
                    }
                  }, "Siguiente"),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  _buildStepTwo(BuildContext context){
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
                child: Image.asset('assets/images/lucho.png', height: screenSizeHeight * 0.25)
            ),
            SizedBox(height: 20.0),
            CardItemWidget(
                text: 'Te llamamos',
                icon: FontAwesomeIcons.phone,
                iconColor: essadeDarkGray,
                iconSize: 25,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(
                          child: HowToContactPage(
                            title: "Te llamamos",
                            text: 'Está atento a tu correo, '
                                'dentro de poco te estaremos enviando respuesta a tu correo.',
                          ),
                          onBackPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                        )
                    )
                )
            ),
            SizedBox(height: 20),
            CardItemWidget(
                text: 'Por correo',
                icon: FontAwesomeIcons.envelopeOpen,
                iconColor: essadeDarkGray,
                iconSize: 25,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(
                          child: HowToContactPage(
                            title: "Por correo",
                            text: 'Está atento a tu teléfono, '
                                'dentro de poco nos comunicaremos contigo.',
                          ),
                          onBackPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                        )
                    )
                )
            ),
            SizedBox(height: 20),
            CardItemWidget(
                text: 'Nos llamas',
                icon: FontAwesomeIcons.headset,
                iconColor: essadeDarkGray,
                iconSize: 25,
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailPage(
                          child: TelDirectoryDetailPage(),
                          onBackPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                        )
                    )
                )
            ),
          ],
        )
    );
  }

  _buildControlButton(Function onPressed, String text, {bool isLarge = false}){
    return SizedBox(
      width: screenSizeHeight * 0.4,
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

  _buildBackButton(){
    return GestureDetector(
      onTap: () => _previousFormStep(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
        child: Text(
          'Atrás',
          style: essadeH4(essadePrimaryColor),
        ),
      ),
    );
  }

  _buildNonCategorySelected(){
    return Container(
      padding: const EdgeInsets.only(left: 15.0),
      child: Text(
          "Debe seleccionar una categoría",
          style: essadeCustomFont(
            fontSize: 12.0,
            color: essadeErrorColor
          )
      )
    );
  }

}
