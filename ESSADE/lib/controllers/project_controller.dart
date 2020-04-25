import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectService{
  getAllProjects(){
    return Firestore.instance
        .collection('proyectos')
        .getDocuments();
  }
}