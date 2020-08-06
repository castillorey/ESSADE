import 'package:cloud_firestore/cloud_firestore.dart';

class Subactivity {
  final String name;
  final Timestamp date;
  final String description;
  final String imagePath;

  Subactivity(this.name, this.date, this.description, this.imagePath);

  Subactivity.fromMap(Map<String, dynamic> map)
      : this.name = map['nombre'],
        this.date = map['fecha'],
        this.description = map['descripcion'],
        this.imagePath = map['ruta_imagen'];

  Subactivity.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);
}
