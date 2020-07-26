import 'package:essade/auth/login_state.dart';
import 'package:essade/ui/stepper_register_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/info_dialog_widget.dart';
import 'package:essade/widgets/long_button_widget.dart';
import 'package:essade/widgets/selectable_widget.dart';
import 'package:essade/widgets/simple_text_form_field_widget.dart';
import 'package:essade/widgets/top_bar_widget.dart';
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
  List<String> idTypes;
  String documentId;
  Color selectableBorderColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    idTypes = ['NIT', 'CC'];
    itemSelected = 'Seleccionar';
    documentIdController = new TextEditingController();
    isDocumentSelected = false;
    documentId = '';
    selectableBorderColor = essadeGray.withOpacity(0.5);
  }

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            TopBarWidget(),
            Divider(),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  _buildContent() {
    return Flexible(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Text(
                'Necesitamos validar que eres nuestro cliente',
                style: essadeTitle(essadeBlack),
              ),
              SizedBox(height: 30.0),
              Text(
                'Tipo de documento',
                style: essadeH5(essadeBlack),
              ),
              SizedBox(height: 10.0),
              SelectableWidget(
                objectKey: 'nombre',
                documents: idTypes,
                initialText: 'Seleccionar',
                onItemSelected: (item) {
                  if (item != null)
                    setState(() {
                      itemSelected = idTypes[item];
                      isDocumentSelected = true;
                    });
                },
                borderColor: selectableBorderColor,
              ),
              SizedBox(height: 10),
              //_myTextFormField(),
              SimpleTextFormFieldWidget(
                label: 'No. ID',
                inputType: TextInputType.text,
                editingController: documentIdController,
                onChanged: () => _formKey.currentState.validate(),
                validationText: 'Ingrese su No. de ID',
                hintText: 'No. de ID',
              ),
              SizedBox(height: 30),
              LongButtonWidget(
                textColor: Colors.white,
                text: 'Validar',
                onPressed: () async {
                  if (!isDocumentSelected) {
                    setState(() {
                      selectableBorderColor = essadeErrorColor;
                    });
                  }
                  if (_formKey.currentState.validate() &&
                      itemSelected != '----') {
                    setState(() {
                      documentId = documentIdController.text;
                    });
                    _handleSubmit(context);
                  }
                },
                backgroundColor: essadePrimaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }

  void onDocumentSelectedCallback() {
    setState(() {
      isDocumentSelected = true;
    });
  }

  Widget _myTextFormField() {
    return TextFormField(
      controller: documentIdController,
      onChanged: (text) {
        _formKey.currentState.validate();
      },
      validator: (String value) {
        if (value.isEmpty) return 'Ingrese su No. de ID';

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
          hintText: 'Ingrese su No. de ID',
          hintStyle: TextStyle(color: Colors.white54, fontFamily: 'Raleway'),
          contentPadding: EdgeInsets.all(20.0),
          errorBorder: essadeBorderErrorStyle(10.0, Colors.white),
          focusedErrorBorder: essadeBorderErrorStyle(10.0, Colors.white),
          errorStyle: TextStyle(color: Colors.white)),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    try {
      showLoadingProgressCircle(context, _keyLoader);
      bool result = await Provider.of<LoginState>(context, listen: false)
          .handleDocumentIdValidation(itemSelected, documentId);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true)
          .pop(); //close loadingCircle
      if (result) {
        print(documentIdController.text);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StepperRegisterPage(
                      noId: documentId,
                    )));
      } else {
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 3), () {
                Navigator.of(context).pop(true);
              });
              return InfoDialogWidget(
                message: 'El No. ID ingresado no se encuentra registrado',
                icon: Icons.error,
                textAlign: TextAlign.center,
              );
            });
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
            return InfoDialogWidget(
                message: 'Lo sentimos ha ocurrido un error :(',
                icon: Icons.error_outline);
          });
    }
  }
}
