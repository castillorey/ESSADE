import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/models/User.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore db = Firestore.instance;
  
  FirebaseUser _user;
  bool _loggedIn = false;
  bool _registerCodeDone = false;
  bool _loading = false;

  bool isLoggedIn() => _loggedIn;
  bool isLoading() => _loading;
  bool isRegisterCodeDone() => _registerCodeDone;
  FirebaseUser currentUser() => _user;

  void googleLogin() async {
    _loading = true;
    notifyListeners();

    //_user = await _handleSignIn();
    _loading = false;
    //_loggedIn = _user != null ? true : false;
    _loggedIn = true;
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
    print('Cerrando sesión');
    _loggedIn = false;
    notifyListeners();
  }

  void codeRegistered(){
    _registerCodeDone = true;
    notifyListeners();
  }

  Future<FirebaseUser> _handleSignIn() async {
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

  Future registerWithEmailAndPassword(String email, String password, String name, String lastname, String mobile) async {
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      User newUser = User(uid: user.uid, name: name, lastname: lastname, mobile: mobile);
      Future ref = db.collection('usuarios').document(user.uid).setData(newUser.toJson());
      emailAndPasswordSignUp();
      return newUser;

    } catch(e){
      print(e.toString());
      return null;
    }

  }

}