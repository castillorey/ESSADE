import 'package:essade/auth/login_state.dart';
import 'package:essade/models/global.dart';
import 'package:essade/ui/about_page.dart';
import 'package:essade/ui/help_page.dart';
import 'package:essade/ui/queries_page.dart';
import 'package:essade/ui/quote_page.dart';
import 'package:essade/ui/stepper_quote_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:essade/widgets/top_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class ContainerPage extends StatefulWidget {
  @override
  _ContainerPageState createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  int _selectedPage = 0;
  final List<Widget> _pageList = [
    HomePage(),
    QuotePage(),
    //StepperQuotePage(),
    QueriesPage(),
    HelpPage(),
    AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
      builder: (BuildContext context, LoginState value, Widget child){
        if(value.isLoading()){
          return Container(
            color: Colors.white,
            child: Center(
                child: CircularProgressIndicator()
            )
          );
        } else {
          return child;
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            TopBarWidget(showBackButton: false),
            Divider(height: 0.0),
            Expanded(
              child: IndexedStack(
                index: _selectedPage,
                children: _pageList,
              ),
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            elevation: 5.0,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Inicio', style: essadeParagraph()),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.graphic_eq),
                title: Text('Cotizar', style: essadeParagraph()),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.zoom_in),
                title: Text('Consultar', style: essadeParagraph()),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.help),
                title: Text('Ayuda', style: essadeParagraph()),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                title: Text('Más', style: essadeParagraph()),
              ),
            ],
            currentIndex: _selectedPage,
            selectedItemColor: primaryColor,
            onTap: _onItemTapped,
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}