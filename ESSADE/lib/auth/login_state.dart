import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/models/User.dart';
import 'package:essade/widgets/info_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore db = Firestore.instance;
  SharedPreferences _prefs;


  User _user;
  bool _loggedIn = false;
  bool _loading = false;
  bool _emailVerified = false;

  LoginState(){
    loginState();
  }

  bool isLoggedIn() => _loggedIn;
  bool isLoading() => _loading;
  bool isEmailVerified() => _emailVerified;
  User currentUser() => _user;

  bool isBiometricActivated(){
    if(_prefs.containsKey('username'))
      return true;

    return false;
  }

  void loginState() async {
    print('Verifying Login state');
    _prefs = await SharedPreferences.getInstance();
    if(_prefs.containsKey('isLoggedIn')){
      _loading = true;
      notifyListeners();
      var currentUser = await getCurrentUser();
      if(currentUser != null && isEmailVerified()){
        _loggedIn = true;
        _user = currentUser;
      } else {
        logout();
      }
      _loading = false;
      notifyListeners();
    }
  }

  void login(BuildContext context, String email, String password) async {
    _loading = true;
    notifyListeners();
    _user = await _handleSignIn(email, password);
    _loading = false;
    notifyListeners();

    if(_user != null){
      print('Iniciando sesión');
      _prefs.setBool('isLoggedIn', true);
      _loggedIn = true;
    }
    else{
      print('Inicio sesión fallido');
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return InfoDialogWidget(
                message: 'Usuario o contraseña incorrecta.',
                textAlign: TextAlign.center,
                icon: Icons.error_outline
            );
          }
      );
    }
  }

  void logout() async {
    try {
      _loading = true;
      notifyListeners();
      await _auth.signOut();
      print('SIGNED OUT SUCCESSFUFLLY');
      Future.delayed(const Duration(seconds: 1), () {
        _loading = false;
        _prefs.remove('isLoggedIn');
        _loggedIn = false;
        notifyListeners();
      });
    } catch(error) {
      print(error.toString());
      _loggedIn = false;
      notifyListeners();
    }
  }

  void emailAndPasswordSignUp(FirebaseUser user) async{
    print('INICIANDO SESION DESPUES DE REGISTRO');
    if(user != null){
      _user = await getCurrentUser();
      print('User: ${_user.toString()}');
      _prefs.setBool('isLoggedIn', true);
      _loggedIn = true;
      print('SESION INICIADA');
    }
    notifyListeners();
  }

  void biometricLogin(BuildContext context){
    login(context, _prefs.get('username'), _prefs.get('password'));
  }

  Future<User> _handleSignIn(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      if(result == null)
        return null;

      print('Email signed correctly');
      _emailVerified = result.user.isEmailVerified;
      User user = User();
      FirebaseUser firebaseUser = result.user;
      print('Email: ${firebaseUser.email}');

      QuerySnapshot _query = await db.collection('usuarios').where('correo', isEqualTo: firebaseUser.email).getDocuments();
      if(_query.documents.length == 0)
        return null;
      print('Email signed correctly and valid');
      user = User.fromSnapshot(_query.documents[0]);
      return user;

    } catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<User> getCurrentUser() async {
    try{
      User user = User();
      var currentUser = await _auth.currentUser();
      QuerySnapshot _query = await db.collection('usuarios').where('correo', isEqualTo: currentUser.email).getDocuments();
      if(_query.documents.length == 0)
        return null;

      _emailVerified = currentUser.isEmailVerified;
      print('ASKING FOR EMAIL?: $_emailVerified');
      user = User.fromSnapshot(_query.documents[0]);

      return user;
    } catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<User> registerWithEmailAndPassword(String email, String password, String name, String noId) async {
    try{

      QuerySnapshot ref = await db.collection('usuarios').where('no_id', isEqualTo: noId).getDocuments();
      if(ref.documents.length == 0)
        return null;
      print('VALID USER signing');
      
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if(result == null)
        return null;
      print('User succesfully created');

      await result.user.sendEmailVerification();
      print('EMail verification sent');

      User newUser = User.fromSnapshot(ref.documents[0]);
      newUser.setName = name;
      newUser.setEmail = email.toLowerCase();
      newUser.setIsRegistered = true;
      db.collection('usuarios').document(newUser.documentID).updateData(newUser.toJson());
      emailAndPasswordSignUp(result.user);

      return newUser;
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<bool> handleDocumentIdValidation(String idType, String noId,) async {
    try {
      QuerySnapshot _query = await db
          .collection('usuarios')
          .where('no_id', isEqualTo: noId)
          .where('tipo_id', isEqualTo: idType)
          .where('registrado', isEqualTo: false).getDocuments();
      if(_query.documents.length != 0)
        return true;

      return false;

    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<void> checkEmailVerification(BuildContext context) async {
    _loading = true;
    notifyListeners();
    var currentUser = await _auth.currentUser();
    await currentUser.reload();

    if(currentUser != null)
      _user = await getCurrentUser();
    else
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return InfoDialogWidget(
                message: 'Su correo no ha sido verificado',
                textAlign: TextAlign.center,
                icon: Icons.error
            );
          }
      );

    _loading = false;
    notifyListeners();

  }

  Future<void> resetPassword(String email) async {
    try {
      _loading = true;
      notifyListeners();
      await _auth.sendPasswordResetEmail(email: email);
      _loading = false;
      notifyListeners();
    } catch(error) {
      print(error);
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> activateBiometric(BuildContext context, String email, String password) async {
    _loading = true;
    notifyListeners();
    _user = await _handleSignIn(email, password);
    if(_user != null){
      print('SIGNED!');
      _prefs.setString('username', email);
      _prefs.setString('password', password);
      await _auth.signOut();
      showDialog(
          context: context,
          builder: (_context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(_context).pop(true);
              Navigator.of(context).pop();
            });
            return InfoDialogWidget(
                message: 'Biométrico activado.',
                textAlign: TextAlign.center,
                icon: Icons.done
            );
          }
      );
    }
    else{
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return InfoDialogWidget(
                message: 'Usuario o contraseña incorrecta.',
                textAlign: TextAlign.center,
                icon: Icons.error_outline
            );
          }
      );
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> disableBiometric(BuildContext context) async {
    try {
      _loading = true;
      notifyListeners();
      bool usr = await _prefs.remove('username');
      bool pswd = await _prefs.remove('password');
        if(usr & pswd){
          showDialog(
              context: context,
              builder: (_context) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(_context).pop(true);
                  Navigator.of(context).pop();
                });
                return InfoDialogWidget(
                    message: 'Biométrico desactivado.',
                    textAlign: TextAlign.center,
                    icon: Icons.done
                );
              }
          );
        } else {
          showDialog(
              context: context,
              builder: (_context) {
                Future.delayed(Duration(seconds: 3), () {
                  Navigator.of(_context).pop(true);
                });
                return InfoDialogWidget(
                    message: 'Lo sentimos ha ocurrido un error.',
                    textAlign: TextAlign.center,
                    icon: Icons.error
                );
              }
          );
        }
      _loading = false;
      notifyListeners();
    } catch(e) {
      print(e);
      return null;
    }

  }

  void googleLogin() async {
    _loading = true;
    notifyListeners();

    //_user = await _handleGoogleSignIn();
    _loading = false;
    //_loggedIn = _user != null ? true : false;
    _loggedIn = true;
    print('Iniciando sesión');
    notifyListeners();

  }

  Future<FirebaseUser> _handleGoogleSignIn() async {
    print('Init _handleSignIn');
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

      if (googleUser != null){
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
        print("signed in " + user.displayName);
        return user;
      }
    } catch (error) {
      print(error);
    }
    return null;
  }

}