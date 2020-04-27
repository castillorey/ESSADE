import 'package:essade/models/global.dart';
import 'package:essade/ui/about_page.dart';
import 'package:essade/ui/help_page.dart';
import 'package:essade/ui/queries_page.dart';
import 'package:essade/ui/quote_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_page.dart';

class ContainerPage extends StatefulWidget {
  @override
  _ContainerPageState createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  int _selectedIndex = 0;
  final List<Widget> tabs = [
    HomePage(),
    QuotePage(),
    QueriesPage(),
    HelpPage(),
    AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.0),
        child: AppBar(
          title: Image.asset('assets/logos/essade.png', height: 60),
          backgroundColor: Colors.white,
          brightness: Brightness.light,
          elevation: _selectedIndex == 0 ? 0.0 : 0.5,
        ),
      ),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 10.0
                        ),
                        child: tabs.elementAt(_selectedIndex)
                      )
                    ],
                  ),
                ),
              ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 5.0,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Inicio', style: essadeParagraph),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.graphic_eq),
            title: Text('Cotizar', style: essadeParagraph),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.zoom_in),
            title: Text('Consultas', style: essadeParagraph),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            title: Text('Ayuda', style: essadeParagraph),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            title: Text('Empresa', style: essadeParagraph),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        onTap: _onItemTapped,
      ),
      backgroundColor: Colors.white,
    );
  }
}