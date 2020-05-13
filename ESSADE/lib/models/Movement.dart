import 'package:cloud_firestore/cloud_firestore.dart';

class Movement{
  final String type;
  final String name;
  final String description;
  final Timestamp startDate;
  final int value;

  Movement(this.type, this.name, this.description, this.startDate, this.value);

  Movement.fromMap(Map<String, dynamic> map)
      :this.type = map['tipo'],
        this.name = map['nombre'],
        this.description = map['descripcion'],
        this.startDate = map['fecha_creacion'],
        this.value = map['valor'];

  Movement.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);

  @override
  String toString() {
    return 'Movement{type: $type, name: $name, description: $description, startDate: $startDate, value: $value}';
  }


}