import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  bool _loggedIn = false;
  bool _loading = false;
  bool _authenticating = false;

  bool isLoggedIn() => _loggedIn;
  bool isLoading() => _loading;
  FirebaseUser currentUser() => _user;
  bool isAuthenticating() => _authenticating;

  void googleLogin() async {
    _authenticating = true;
    _loading = true;
    notifyListeners();

    _user = await _handleSignIn();
    _loading = false;
    _authenticating = false;
    _loggedIn = _user != null ? true : false;
    print('Iniciando sesión');
    notifyListeners();
    
  }

  void logout(){
    _authenticating = true;
    _googleSignIn.signOut();
    print('Cerrando sesión');
    _loggedIn = false;
    notifyListeners();
    _authenticating = false;
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
}