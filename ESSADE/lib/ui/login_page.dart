import 'package:essade/auth/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:essade/ui/signin_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<LoginState>(
          builder: (BuildContext context, LoginState value, Widget child){
            if(value.isLoading()){
              return CircularProgressIndicator();
            } else {
              return child;
            }
          },
          child: Column(
            children: <Widget>[
              RaisedButton(
                  child: Text('Login in'),
                  onPressed: (){
                    Provider.of<LoginState>(context, listen: false).login();
                  }
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                  child: Text('Sign in'),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  }
              ),
            ],
          )
        ),
      ),
    );
  }
}


