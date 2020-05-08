import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/models/User.dart';
import 'package:essade/widgets/info_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore db = Firestore.instance;
  
  User _user;
  bool _loggedIn = false;
  bool _registerCodeDone = false;
  bool _loading = false;

  bool isLoggedIn() => _loggedIn;
  bool isLoading() => _loading;
  bool isRegisterCodeDone() => _registerCodeDone;
  User currentUser() => _user;

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

  void login(BuildContext context, String email, String password) async {
    _loading = true;
    notifyListeners();

    _user = await _handleSignIn(email, password);
    _loading = false;

    if(_user != null)
      _loggedIn = true;
    else
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

    print('Iniciando sesión');
    notifyListeners();
  }

  void emailAndPasswordSignUp() {
    _loggedIn = true;
    print('Iniciando sesión');
    notifyListeners();
  }

  void logout(){
    //_googleSignIn.signOut();
    _auth.signOut().then((onValue) {
      print('SIGNED OUT SUCCESSFUFLLY');
    }).catchError((onError){
      print(onError);
    });

    _loggedIn = false;
    notifyListeners();
  }

  void codeRegistered(){
    _registerCodeDone = true;
    notifyListeners();
  }

  Future<User> _handleSignIn(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);

      if(result == null)
        return null;

      FirebaseUser firebaseUser = result.user;
      DocumentSnapshot _user = await db.collection('usuarios').document(firebaseUser.uid).get();
      User user = User.fromMap(_user.data);

      return user;
    } catch(error){
      print(error.toString());
      return null;
    }
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

  Future registerWithEmailAndPassword(String email, String password, String name) async {
    try{
      /* Need to pass de Document id from register code and find that user and set info*/
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      User newUser = User(uid: user.uid, name: name);
      Future ref = db.collection('usuarios').document(user.uid).setData(newUser.toJson());
      emailAndPasswordSignUp();
      return newUser;

    } catch(e){
      print(e.toString());
      return null;
    }

  }

}