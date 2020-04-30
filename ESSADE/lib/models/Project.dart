import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  final String name, city, state;
  final int income, outgoing, activitiesNumber, price;
  final Map<String, dynamic> tasksPercentage;
  final String id;

  /*Project(
      this.name,
      this.city,
      this.state,
      this.income,
      this.outgoing,
      this.activitiesNumber,
      this.price,
      this.tasksPercentage, this.reference
      );*/

  Project.fromMap(Map<String, dynamic> map, {this.id})
      : this.name = map['nombre'],
        this.city = map['ciudad'],
        this.state = map['departamento'],
        this.income = map['ingreso'],
        this.outgoing = map['egreso'],
        this.activitiesNumber = map['no_actividades'],
        this.price = map['valor_total'],
        this.tasksPercentage = map['tareas_porcentaje'];

  Project.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, id: snapshot.documentID);

  @override
  String toString() {
    return 'Project{name: $name, city: $city, state: $state, income: $income, outgoing: $outgoing, activitiesNumber: $activitiesNumber, price: $price, tasksPercentage: $tasksPercentage, reference: $id}';
  }


}