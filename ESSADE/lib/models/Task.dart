import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final name;
  final description;
  final startDate;
  final percentageDone;
  final imagePath;

  Task(this.name, this.percentageDone, this.description, this.startDate, this.imagePath);

  Task.fromMap(Map<String, dynamic> map)
      : this.name = map['nombre'],
        this.description = map['descripcion'],
        this.startDate = map['fecha_creacion'],
        this.percentageDone = map['porcentaje'],
        this.imagePath = map['ruta_imagen'];

  Task.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);
}