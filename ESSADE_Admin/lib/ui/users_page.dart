import 'package:ESSADE_Admin/controllers/users_repository.dart';
import 'package:ESSADE_Admin/models/User.dart';
import 'package:ESSADE_Admin/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  Stream<QuerySnapshot> _usersQuery;

  List<User> _users = [];
  List<User> _filteredUsers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usersQuery = UsersRepository().queryAll();
    _usersQuery.listen((event) {
      event.documents.forEach((element) => _users.add(User.fromSnapshot(element)));
      _filteredUsers = _users;
    }).onError((error) => print(error));
  }

  void filterUsers(value){
    setState(() {
      _filteredUsers = _users.where((user) => user.name.toLowerCase().contains(value)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Usuarios', style: essadeH4(essadeBlack)),
        SizedBox(height: 20.0),
        StreamBuilder(
            stream: _usersQuery,
            builder: (context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                var documents = snapshot.data.documents;
                var _index = 0;
                return Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15.0))
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildFilterTextField(),
                          _buildNewUserButton()
                        ],
                      ),
                      SizedBox(height: 20.0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          sortColumnIndex: 0,
                          columns: [
                            DataColumn(
                              label: Text("No.", style: essadeParagraph(color: essadeBlack)),
                              numeric: true,
                            ),
                            DataColumn(
                              label: Text("Tipo ID", style: essadeParagraph(color: essadeBlack)),
                              numeric: false,
                            ),
                            DataColumn(
                              label: Text("No. ID", style: essadeParagraph(color: essadeBlack)),
                              numeric: false,
                            ),
                            DataColumn(
                              label: Text("Estado", style: essadeParagraph(color: essadeBlack)),
                              numeric: false,
                            ),
                            DataColumn(
                              label: Text("Nombre", style: essadeParagraph(color: essadeBlack)),
                              numeric: false,
                            ),
                            DataColumn(
                              label: Text("Correo", style: essadeParagraph(color: essadeBlack)),
                              numeric: false,
                            ),
                          ],
                          rows: _filteredUsers.map((user){
                            _index++;
                            var stateColor = user.signed ? essadeIncomeColor : essadeErrorColor;
                            var stateText = user.signed ? 'Registrado' : 'No registrado';
                            return DataRow(
                                cells: [
                                  DataCell(
                                    Text('$_index', style: essadeLightfont(essadeBlack)),
                                  ),
                                  DataCell(
                                    Text(user.idType, style: essadeLightfont(essadeBlack)),
                                    onTap: () {
                                      // write your code..
                                    },
                                  ),
                                  DataCell(
                                    Text(user.noId, style: essadeLightfont(essadeBlack)),
                                    onTap: () {
                                      // write your code..
                                    },
                                  ),
                                  DataCell(
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                                      decoration: BoxDecoration(
                                          color: stateColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.all(Radius.circular(25.0))
                                      ),
                                      child: Text(
                                        stateText,
                                        style: essadeLightfont(stateColor),
                                      ),
                                    ),
                                    onTap: () {
                                      // write your code..
                                    },
                                  ),
                                  DataCell(
                                    Text(user.name, style: essadeLightfont(essadeBlack)),
                                    onTap: () {
                                      // write your code..
                                    },
                                  ),
                                  DataCell(
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(user.email, style: essadeLightfont(essadeBlack)),
                                          SizedBox(width: 15.0),
                                          InkWell(
                                              onTap: (){},
                                              child: Icon(Icons.more_horiz)
                                          )
                                        ],
                                      )
                                  ),
                                ]
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  )
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
        )
      ],
    );
  }

  _buildFilterTextField(){
    return Container(
      width: 200,
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: essadeGray.withOpacity(0.5)
        ),
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      child: TextField(
        cursorColor: essadePrimaryColor,
        onChanged: (value) => filterUsers(value),
        style: essadeLightfont(essadeBlack),
        decoration: InputDecoration(
          icon: Icon(Icons.filter_list, color: essadeGray),
          hintText: 'Filtrar: por nombre',
          hintStyle: essadeLightfont(essadeGray),
          border: InputBorder.none
        ),
      )
    );
  }

  _buildNewUserButton(){
    return RaisedButton(
      elevation: 1.0,
      onPressed: () {},
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      color: essadePrimaryColor,
      child: Row(
        children: [
          Icon(Icons.add, color: Colors.white, size: 20.0),
          SizedBox(width: 10.0),
          Text('Agregar usuario', style: essadeLightfont(Colors.white))
        ],
      ),
    );
  }
}
