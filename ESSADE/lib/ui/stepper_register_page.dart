import 'package:essade/auth/login_state.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/info_dialog_widget.dart';
import 'package:essade/widgets/simple_text_form_field_widget.dart';
import 'package:essade/widgets/top_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class StepperRegisterPage extends StatefulWidget {
  final String noId;

  const StepperRegisterPage({Key key, this.noId}) : super(key: key);
  @override
  _StepperRegisterPageState createState() => _StepperRegisterPageState();
}

class _StepperRegisterPageState extends State<StepperRegisterPage> {
  PageController _formsPageViewController = PageController();
  TextEditingController nameInputController = TextEditingController();
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  TextEditingController repeatPasswordInputController = TextEditingController();
  List _formSteps = [];
  String _name;
  String _email;
  String _password;
  String _noId;

  int currentPageValue;

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

  void getChangedPage(int page) {
    setState(() {
      currentPageValue = page;
    });
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

    currentPageValue = 0;

    _name = '';
    _email= '';
    _password = '';
    _noId = widget.noId;

  }

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: Column(
          children: [
            TopBarWidget(),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: _buildBody()
            ),
          ],
        )
      ),
    );
  }

  _buildBody(){
    double topBarHeight = 90;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height - topBarHeight,
            child: PageView.builder(
              controller: _formsPageViewController,
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
      ),
    );
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
                'Empecemos con tus datos personales',
                style: essadeH3(essadeBlack),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _nextButton(() {
                  FocusScope.of(context).unfocus();
                  if(_formKey.currentState.validate()){
                    setState(() {
                      _name = nameInputController.text;
                      _email = emailInputController.text;
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
                'Ahora tus credenciales de ingreso',
                style: essadeH3(essadeBlack),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Text(
                  'Crea tu contraseña',
                  style: essadeH5(essadeBlack),
                ),
                SizedBox(width: 5.0),
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
              validateNewPassword: true,
              inputType: TextInputType.visiblePassword,
              editingController: passwordInputController,
              onChanged: () => _formKey.currentState.validate(),
              validationText: 'Ingrese una contraseña',
              hintText: 'Nueva contraseña',
            ),
            SizedBox(height: 5.0),
            Text(
              'Solo para confirmar',
              style: essadeH5(essadeBlack),
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
                  contentPadding: EdgeInsets.all(18.0),
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
                      _password = passwordInputController.text;
                    });
                    _handleRegisterSubmit(context);
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
        currentPageValue == _formSteps.length ? 'Enviar' : 'Siguiente',
        style: essadeH4(Colors.white),
      ),
    );
  }

  Future<void> _handleRegisterSubmit(BuildContext context) async {
    try{
      showLoadingProgressCircle(context, _keyLoader);
      dynamic result = await Provider.of<LoginState>(context, listen: false)
          .registerWithEmailAndPassword(_email, _password, _name, _noId);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();//close showLoadingProgressCircle
      if(result == null){
        _myShowDialog(context, 'Hay algo raro con el correo proporcionado. Échale un vistaso');
        return null;
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch(error){
      print(error);
      _myShowDialog(context, 'Lo sentimos, ha ocurrido un error muy raro');
    }
  }

  _myShowDialog(BuildContext context, String message){
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 3), () {
            Navigator.of(context).pop(true);
          });
          return InfoDialogWidget(
              message: message,
              textAlign: TextAlign.center,
              icon: Icons.error_outline
          );
        }
    );
  }
}
