import 'package:cloud_firestore/cloud_firestore.dart';

class Movement{
  final String projectId;
  final String type;
  final String name;
  final String description;
  final Timestamp startDate;

  Movement(this.projectId, this.type, this.name, this.description, this.startDate);

  Movement.fromMap(Map<String, dynamic> map)
      : this.projectId = map['id_proyecto'],
        this.type = map['tipo'],
        this.name = map['nombre'],
        this.description = map['descripcion'],
        this.startDate = map['fecha_creacion'];

  Movement.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data);

  @override
  String toString() {
    return 'Movement{projectId: $projectId, type: $type, name: $name, description: $description, startDate: $startDate}';
  }


}