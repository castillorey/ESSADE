import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectsRepository {
  final String userId;

  ProjectsRepository(this.userId);

  Stream<QuerySnapshot> queryAll(){
    return Firestore.instance
        .collection('usuarios').document(userId)
        .collection('proyectos').snapshots();
  }

  Stream<QuerySnapshot> queryMovements(String projectId){
    return Firestore.instance
        .collection('usuarios').document(userId)
        .collection('proyectos').document(projectId)
        .collection('movimientos').snapshots();
  }

  Stream<QuerySnapshot> queryActivities(String projectId){
    return Firestore.instance
        .collection('usuarios').document(userId)
        .collection('proyectos').document(projectId)
        .collection('actividades').snapshots();
  }

  Future<DocumentReference> addQuote(String serviceType, String comment) {
    return Firestore.instance.collection('usuarios')
        .document(userId).collection('cotizaciones').add({
      'tipo_servicio': serviceType,
      'comentario': comment
    });
  }

  Future<DocumentReference> addSuggestion(String comment) {
    return Firestore.instance.collection('usuarios')
        .document(userId).collection('sugerencias').add({
      'comentario': comment
    });
  }
}