import 'package:essade/auth/login_state.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/info_dialog.dart';
import 'package:essade/widgets/simple_text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class StepperRegisterPage extends StatefulWidget {
  @override
  _StepperRegisterPageState createState() => _StepperRegisterPageState();
}

class _StepperRegisterPageState extends State<StepperRegisterPage> {
  PageController _formsPageViewController = PageController();
  TextEditingController nameInputController = TextEditingController();
  TextEditingController lastnameInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController mobileInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  TextEditingController repeatPasswordInputController = TextEditingController();
  List _formSteps;
  String name;
  String lastname;
  String email;
  String mobile;
  String password;

  LoginState _auth = LoginState();

  void _nextFormStep() {
    _formsPageViewController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void _previousFormStep(){
    _formsPageViewController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  bool onWillPop() {
    if (_formsPageViewController.page.round() ==
        _formsPageViewController.initialPage) return true;

    _formsPageViewController.previousPage(
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
        child: Step1Container(context),
      ),
      WillPopScope(
        onWillPop: () => Future.sync(this.onWillPop),
        child: Step2Container(context),
      ),
    ];

    name = '';
    lastname = '' ;
    email= '';
    mobile = '';
    password = '';

  }

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.close, color: essadeBlack),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor: Colors.transparent,
            brightness: Brightness.light,
            elevation: 0.0,
          ),
          body: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: _buildBody()
          )
      ),
    );
  }

  Widget _buildBody(){
    double appBarHeight = AppBar().preferredSize.height;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - appBarHeight - 10,
            child: PageView.builder(
              controller: _formsPageViewController,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return _formSteps[index];
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget Step2Container(BuildContext context){
    final _formKey = GlobalKey<FormState>();
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
              child: Text(
                'AHORA TUS CREDENCIALES DE INGRESO',
                style: essadeH3(essadeBlack),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Correo electrónico',
              style: essadeH5(essadePrimaryColor),
            ),
            SimpleTextFormFieldWidget(
              inputType: TextInputType.emailAddress,
              editingController: emailInputController,
              onChanged: () => _formKey.currentState.validate(),
              validationText: 'Ingrese su correo electrónico',
              hintText: 'Su correo electrónico',
            ),
            SizedBox(height: 5.0),
            Row(
              children: <Widget>[
                Text(
                  'Crea tu contraseña',
                  style: essadeH5(essadePrimaryColor),
                ),
                SizedBox(width: 10.0),
                GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (context) {
                          Future.delayed(Duration(seconds: 7), () {
                            Navigator.of(context).pop(true);
                          });
                          return InfoDialogWidget(
                              message: 'La contraseña debe tener:\n'
                                  '* Al menos 8 caractéres\n'
                                  '* Al menos una letra\n'
                                  '* Y al menos un número\n',
                              icon: Icons.warning
                          );
                        }
                    );
                  },
                  child: Icon(
                    Icons.info,
                    color: essadeDarkGray,
                  ),
                )
              ],
            ),
            SimpleTextFormFieldWidget(
              obscureText: true,
              inputType: TextInputType.visiblePassword,
              editingController: passwordInputController,
              onChanged: () => _formKey.currentState.validate(),
              validationText: 'Ingrese una contraseña',
              hintText: 'Nueva contraseña',
            ),
            SizedBox(height: 5.0),
            Text(
              'Solo para confirmar',
              style: essadeH5(essadePrimaryColor),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                obscureText: true,
                controller: repeatPasswordInputController,
                onChanged: (text) => _formKey.currentState.validate(),
                validator: (String value){
                  if (value.isEmpty)
                    return 'Debe repetir la contraseña';

                  if(value != passwordInputController.text)
                    return 'Las contraseñas no coinciden';

                  return null;
                },
                keyboardType: TextInputType.visiblePassword,
                style: TextStyle(color: essadeBlack, fontFamily: 'Raleway'),
                decoration: InputDecoration(
                  hintText: 'Repetir contraseña',
                  hintStyle: TextStyle(color: essadeGray, fontFamily: 'Raleway'),
                  contentPadding: EdgeInsets.all(10.0),
                  enabledBorder: essadeBorderErrorStyle(15.0, essadeGray.withOpacity(0.5)),
                  focusedBorder: essadeBorderErrorStyle(15.0, essadePrimaryColor),
                  errorBorder: essadeBorderErrorStyle(15.0, essadeErrorColor),
                  focusedErrorBorder: essadeBorderErrorStyle(15.0, essadePrimaryColor),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _backButton(),
                _nextButton(() async {
                  if(_formKey.currentState.validate()){
                    setState(() {
                      email = emailInputController.text;
                      password = passwordInputController.text;
                    });

                  }
                })
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handleRegisterSubmit(BuildContext context) async {
    try{
      showLoadingProgressCircle(context, _keyLoader);
      dynamic result = await _auth.registerWithEmailAndPassword(email, password, name, lastname, mobile);
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();//close showLoadingProgressCircle
      Navigator.popUntil(context, ModalRoute.withName('/'));

    } catch(error){
      print(error);
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 7), () {
              Navigator.of(context).pop(true);
            });
            return InfoDialogWidget(
                message: 'Lo sentimos, ha ocurrido un error.',
                icon: Icons.error_outline
            );
          }
      );
    }
  }

  static Future<void> showLoadingProgressCircle(BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: Center(
                key: key,
                child: CircularProgressIndicator(),
              )
          );
        });
  }

  Widget Step1Container(BuildContext context){
    final _formKey = GlobalKey<FormState>();

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
              child: Text(
                'EMPECEMOS CON TUS DATOS PERSONALES',
                style: essadeH3(essadeBlack),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              '¿Cuál es su nombre?',
              style: essadeH5(essadePrimaryColor),
            ),
            SimpleTextFormFieldWidget(
              inputType: TextInputType.text,
              editingController: nameInputController,
              onChanged: () => _formKey.currentState.validate(),
              validationText: 'Ingrese su nombre',
              hintText: 'Su nombre',
            ),
            SizedBox(height: 5.0),
            Text(
              '¿Y su apellido?',
              style: essadeH5(essadePrimaryColor),
            ),
            SimpleTextFormFieldWidget(
              inputType: TextInputType.text,
              editingController: lastnameInputController,
              onChanged: () => _formKey.currentState.validate(),
              validationText: 'Ingrese su apellido',
              hintText: 'Su apellido',
            ),
            SizedBox(height: 5.0),
            Text(
              'No. móvil',
              style: essadeH5(essadePrimaryColor),
            ),
            SimpleTextFormFieldWidget(
              inputType: TextInputType.number,
              editingController: mobileInputController,
              onChanged: () => _formKey.currentState.validate(),
              validationText: 'Ingrese su número móvil',
              hintText: 'Su número móvil',
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _nextButton(() {
                  FocusScope.of(context).unfocus();
                  if(_formKey.currentState.validate()){
                    setState(() {
                      name = nameInputController.text;
                      lastname = lastnameInputController.text;
                      mobile = mobileInputController.text;
                    });
                    _nextFormStep();
                  }

                })
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _backButton(){
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

  Widget _nextButton(Function onPressed){
    return RaisedButton(
      elevation: 5.0,
      onPressed: onPressed,
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 25.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      color: essadePrimaryColor,
      child: Text(
        'Siguiente',
        style: essadeH4(Colors.white),
      ),
    );
  }
}
