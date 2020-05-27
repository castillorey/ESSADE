import 'package:cloud_firestore/cloud_firestore.dart';

class UsersRepository {
  String userId;

  UsersRepository({this.userId});

  Stream<QuerySnapshot> queryAll(){
    return Firestore.instance
        .collection('usuarios').snapshots();
  }

  Stream<DocumentSnapshot> getUser(String userId){
    return Firestore.instance
        .collection('usuarios').document(userId).snapshots();
  }
}


