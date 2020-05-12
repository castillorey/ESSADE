import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:essade/models/User.dart';
import 'package:essade/utilities/constants.dart';
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
  bool _registerIdDone = false;
  bool _loading = false;

  bool isLoggedIn() => _loggedIn;
  bool isLoading() => _loading;
  bool isRegisterCodeDone() => _registerIdDone;
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

    if(_user != null){
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


  void validateDocumentId(BuildContext context, String idType, String noId) async {
    _loading = true;
    notifyListeners();

    _registerIdDone = await handleDocumentIdValidation(idType, noId);
    _loading = false;

    if(_registerIdDone){
      documentIdRegistered();
    } else {
      showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop(true);
            });
            return InfoDialogWidget(
                message: 'El No. Id ingresado no se encuetra registrado.',
                textAlign: TextAlign.center,
                icon: Icons.error_outline
            );
          }
      );
    }
    print('Validating Document');
    notifyListeners();
  }

  void emailAndPasswordSignUp(User user) {
    _user = user;
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

  void documentIdRegistered(){
    _registerIdDone = true;
    notifyListeners();
  }

  Future<User> _handleSignIn(String email, String password) async {
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);

      if(result == null)
        return null;

      print('Hasta ahora aquí vamos bien');
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

      QuerySnapshot ref = await db.collection('usuarios').where('no_id', isEqualTo: noId).getDocuments();
      print(ref.documents);
      if(ref.documents.length == 0)
        return null;


      User newUser = User.fromSnapshot(ref.documents[0]);
      newUser.setName = name;
      newUser.setEmail = email;
      newUser.setIsRegistered = true;

      db.collection('usuarios').document(newUser.documentID).updateData(newUser.toJson());
      emailAndPasswordSignUp(newUser);

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
          .where('tipo_id', isEqualTo: idType).where('registrado', isEqualTo: false).getDocuments();
      if(_query.documents.length != 0)
        return true;

      return false;

    } catch (error) {
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

}