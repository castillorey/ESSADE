import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String project_id;
  final String name;
  final String description;
  final Timestamp start_date;
  final String image_path;
  final String documentID;
  final int progress;

  Activity(this.project_id, this.name, this.description, this.start_date,
      this.image_path, this.documentID, this.progress);

  Activity.fromMap(Map<String, dynamic> map, {this.documentID})
      : this.project_id = map['id_proyecto'],
        this.name = map['nombre'],
        this.description = map['descripcion'],
        this.start_date = map['fecha_creacion'],
        this.image_path = map['ruta_imagen'],
        this.progress = map['porcentaje'];

  Activity.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, documentID: snapshot.documentID);

  @override
  String toString() {
    return 'Activity{project_id: $project_id, name: $name, description: $description, start_date: $start_date, image_path: $image_path}, progress: $progress}';
  }
}
