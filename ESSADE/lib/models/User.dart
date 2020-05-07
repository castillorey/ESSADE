class User {
  final String uid;
  final String name;
  final String idTypE;

  User({this.idTypE, this.uid, this.name,});

  User.fromMap(Map<String, dynamic> map)
      : this.idTypE = map['tipo_id'],
        this.uid = map['id'],
        this.name = map['nombre'];


  Map<String, dynamic> toJson() =>
      {
        'tipo_id' : idTypE,
        'id' : uid,
        'nombre' : name
      };
}