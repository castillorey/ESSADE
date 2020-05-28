import 'package:ESSADE_Admin/models/User.dart';
import 'package:ESSADE_Admin/utilities/constants.dart';
import 'package:flutter/material.dart';

class UserOptionDialogWidget extends StatelessWidget {
  final User user;

  const UserOptionDialogWidget({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildEditSection(),
            SizedBox(height: 15.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildOptionButton('Editar', essadeDarkGray, Icons.add),
                SizedBox(width: 8.0),
                _buildOptionButton('Eliminar', essadeErrorColor, Icons.delete),
              ],
            )
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
    );
  }

  _buildEditSection(){
    return Column(
      children: [
        Text('Editar usuario', style: essadeH5(essadeBlack)),
      ],
    );
  }

  _buildOptionButton(String text, Color color, IconData icon){
    return Container(
      child: RaisedButton(
        elevation: 1.0,
        onPressed: () {},
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        color: color.withOpacity(0.8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20.0),
            SizedBox(width: 5.0),
            Text(text, style: essadeLightfont(Colors.white))
          ],
        ),
      ),
    );
  }
}
