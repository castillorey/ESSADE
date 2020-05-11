class User {
  final String noId;
  final String name;
  final String idTypE;
  final String email;

  User({this.email, this.idTypE, this.noId, this.name,});

  User.fromMap(Map<String, dynamic> map)
      : this.idTypE = map['tipo_id'],
        this.noId= map['no_id'],
        this.name = map['nombre'],
        this.email = map['correo'];


  Map<String, dynamic> toJson() =>
      {
        'tipo_id' : idTypE,
        'no_id' : noId,
        'nombre' : name,
        'correo' : email
      };
}