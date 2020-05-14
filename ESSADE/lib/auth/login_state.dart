import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/models/User.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/info_dialog.dart';
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

  void loginState() async {
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

  Future<User> getCurrentUser() async {
    try{
      User user = User();
      var currentUser = await _auth.currentUser();
      QuerySnapshot _query = await db.collection('usuarios').where('correo', isEqualTo: currentUser.email).getDocuments();
      if(_query.documents.length == 0)
        return null;
      _emailVerified = currentUser.isEmailVerified;
      user = User.fromSnapshot(_query.documents[0]);

      return user;
    } catch(error){
      print(error.toString());
      return null;
    }
  }

  void login(BuildContext context, String email, String password) async {
    _loading = true;
    notifyListeners();
    _user = await _handleSignIn(email, password);
    _loading = false;

    if(_user != null){
      _prefs.setBool('isLoggedIn', true);
      _loggedIn = true;
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

    print('Iniciando sesión');
    notifyListeners();
  }

  Future<bool> checkEmailVerification() async {
    _loading = true;
    notifyListeners();
    var currentUser = await _auth.currentUser();
    await currentUser.reload();
    _loading = false;
    print('CURRENT USER: $currentUser');

    _emailVerified = currentUser.isEmailVerified;
    print('IS VERIFIED?: $_emailVerified');
    notifyListeners();
    if(_emailVerified) {
      return true;
    } else {
      return false;
    }
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

  void emailAndPasswordSignUp(FirebaseUser user) async{
    //_loading = true;
    //notifyListeners();
    //_user = await _handleSignIn(email, password);
    //_loading = false;
    print('INICIANDO SESION DESPUES DE REGISTRO');
    if(user != null){
      _user = await getCurrentUser();
      _prefs.setBool('isLoggedIn', true);
      _loggedIn = true;
      print('SESION INICIADA');
    }
    notifyListeners();
  }

  void logout() async {
    try {
      _loading = true;
      notifyListeners();
      await _auth.signOut();
      print('SIGNED OUT SUCCESSFUFLLY');
      Future.delayed(const Duration(seconds: 1), () {
        _loading = false;
        _prefs.clear();
        _loggedIn = false;
        notifyListeners();
      });
    } catch(error) {
      print(error.toString());
      _loggedIn = false;
      notifyListeners();
    }
  }

  Future<User> _handleSignIn(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);

      if(result == null)
        return null;

      if(result.user.isEmailVerified)
        _emailVerified = true;

      User user = User();
      FirebaseUser firebaseUser = result.user;
      QuerySnapshot _query = await db.collection('usuarios').where('correo', isEqualTo: firebaseUser.email).getDocuments();
      if(_query.documents.length == 0)
        return null;

      user = User.fromSnapshot(_query.documents[0]);

      return user;
    } catch(error){
      print(error.toString());
      return null;
    }
  }

  Future<User> registerWithEmailAndPassword(String email, String password, String name, String noId) async {
    try{
      
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if(result == null)
        return null;

      await result.user.sendEmailVerification();
      print('EMail verification sent');

      QuerySnapshot ref = await db.collection('usuarios').where('no_id', isEqualTo: noId).getDocuments();
      if(ref.documents.length == 0)
        return null;

      User newUser = User.fromSnapshot(ref.documents[0]);
      newUser.setName = name;
      newUser.setEmail = email;
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