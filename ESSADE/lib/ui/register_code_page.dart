import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/auth/login_state.dart';
import 'package:essade/ui/signup_page.dart';
import 'package:essade/ui/stepper_register_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/info_dialog_widget.dart';
import 'package:essade/widgets/long_button_widget.dart';
import 'package:essade/widgets/selectable_widget.dart';
import 'package:essade/widgets/simple_text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterCodePage extends StatefulWidget {
  @override
  _RegisterCodePageState createState() => _RegisterCodePageState();
}

class _RegisterCodePageState extends State<RegisterCodePage> {
  TextEditingController documentIdController;
  bool isDocumentSelected;
  String itemSelected;
  List<String> idTypes = ['NIT', 'CC'];
  String documentId;
  Color selectableBorderColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    itemSelected = '----';
    documentIdController = new TextEditingController();
    isDocumentSelected = false;
    documentId = '';
    selectableBorderColor = essadeGray.withOpacity(0.2);
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: essadePrimaryColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              color: essadePrimaryColor,
              padding: EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 40
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'NECESITAMOS VALIDAR QUE ERES NESTRO CLIENTE',
                      style: essadeTitle(Colors.white),
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      'Tipo de documento',
                      style: essadeH5(Colors.white),
                    ),
                    SizedBox(height: 10.0),
                    SelectableWidget(
                      objectKey: 'nombre',
                      documents: idTypes,
                      initialText: 'Tipo de documento',
                      textColor: Colors.white,
                      onItemSelected: (item){
                        if(item != null)
                          setState(() {
                            itemSelected = idTypes[item];
                            isDocumentSelected = true;
                          });
                      },
                      borderColor: selectableBorderColor,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No. id',
                      style: essadeH5(Colors.white),
                    ),
                    SizedBox(height: 10.0),
                    _myTextFormField(),
                    SizedBox(height: 30),
                    LongButtonWidget(
                      textColor: essadePrimaryColor,
                      text: 'Validar',
                      onPressed: () async {
                        if(!isDocumentSelected){
                          setState(() {
                            selectableBorderColor = Colors.white;
                          });
                        }
                        if (_formKey.currentState.validate() && itemSelected != '----'){
                          setState(() {
                            documentId = documentIdController.text;
                          });
                          _handleSubmit(context);
                        }
                      },
                      backgroundColor: Colors.white,
                    )
                  ],
                ),
              ),
            )
          ),
        ),
      ),
    );
  }

  void onDocumentSelectedCallback(){
    setState(() {
      isDocumentSelected = true;
    });
  }
  Widget _myTextFormField(){
    return TextFormField(
      controller: documentIdController,
      onChanged: (text){
        _formKey.currentState.validate();
      },
      validator: (String value){
        if (value.isEmpty)
          return 'Ingrese su No. de id';

        return null;
      },
      cursorColor: Colors.white,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
      decoration: InputDecoration(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(width: 0, style: BorderStyle.none),
          ),
          fillColor: essadeGray.withOpacity(0.3),
          hintText: 'Ingrese su No. de id',
          hintStyle: TextStyle(color: Colors.white54, fontFamily: 'Raleway'),
          contentPadding: EdgeInsets.all(20.0),
          errorBorder: essadeBorderErrorStyle(10.0, Colors.white),
          focusedErrorBorder: essadeBorderErrorStyle(10.0, Colors.white),
          errorStyle: TextStyle(color: Colors.white)
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    try {
      showLoadingProgressCircle(context, _keyLoader);
      bool result = await Provider.of<LoginState>(context, listen: false)
          .handleDocumentIdValidation(itemSelected, documentId);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();//close loadingCircle
      if(result){
        print(documentIdController.text);
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StepperRegisterPage(noId: documentId,))
        );
      } else {
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop(true);
              });
              return InfoDialogWidget(
                message: 'El No. Id ingresado no se encuentra registrado.',
                icon: Icons.error,
                textAlign: TextAlign.center,
              );
            }
        );
      }
      documentIdController.clear();
    } catch (error) {
      print(error);
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return InfoDialogWidget(message: 'Lo sentimos ha ocurrido un error :(', icon: Icons.error_outline);
          }
      );
    }
  }
}
