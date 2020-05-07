class User {
  final String uid;
  final String name;
  final String lastname;
  final String mobile;

  User({this.name, this.lastname, this.mobile, this.uid });

  Map<String, dynamic> toJson() =>
      {
        'nombre': name,
        'apellido': lastname,
        'celular': mobile,
      };
}