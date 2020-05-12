import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String noId;
  String name;
  final String idTypE;
  String email;
  bool signed;
  String documentID;

  User({this.email, this.idTypE, this.noId, this.name,this.signed = false, this.documentID});

  User.fromMap(Map<String, dynamic> map, {this.documentID})
      : this.idTypE = map['tipo_id'],
        this.noId= map['no_id'],
        this.name = map['nombre'],
        this.email = map['correo'],
        this.signed = map['registrado'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, documentID: snapshot.documentID);


  Map<String, dynamic> toJson() =>
      {
        'tipo_id' : idTypE,
        'no_id' : noId,
        'nombre' : name,
        'correo' : email,
        'registrado' : signed
      };



  set setName(String newName) {
    this.name = newName;
  }

  set setEmail(String newEmail) {
    this.email = newEmail;
  }

  set setIsRegistered(bool isRegistered) {
    this.signed = isRegistered;
  }



}