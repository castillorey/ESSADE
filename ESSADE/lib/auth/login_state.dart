import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  bool _loggedIn = false;
  bool _loading = false;

  bool isLoggedIn() => _loggedIn;
  bool isLoading() => _loading;
  FirebaseUser currentUser() => _user;

  void login() async {
    _loading = true;
    notifyListeners();

    _user = await _handleSignIn();
    _loading = false;
    _loggedIn = _user != null ? true : false;
    notifyListeners();
    
  }

  void logout(){
    _googleSignIn.signOut();
    _loggedIn = false;
    notifyListeners();
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }
}