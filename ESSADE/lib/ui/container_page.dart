import 'package:essade/models/global.dart';
import 'package:essade/ui/about_page.dart';
import 'package:essade/ui/help_page.dart';
import 'package:essade/ui/queries_page.dart';
import 'package:essade/ui/quote_page.dart';
import 'package:essade/utilities/constants.dart';
import 'package:flutter/material.dart';

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
    body: Center(
      child: tabs.elementAt(_selectedIndex),
    ),
    bottomNavigationBar: BottomNavigationBar(
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
  );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('ESSADE'),
    //   ),
    //   body: Center(
    //     child: tabs.elementAt(_selectedIndex),
    //   ),      
    //   bottomNavigationBar: BottomNavigationBar(
    //     type: BottomNavigationBarType.fixed,
    //     items: [
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.home),
    //         title: Text('Inicio'),
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.graphic_eq),
    //         title: Text('Cotizar'),            
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.zoom_in),
    //         title: Text('Consultas'),
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.help),
    //         title: Text('Ayuda'),
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.menu),
    //         title: Text('Empresa'),
    //       ),
    //     ],
    //     currentIndex: _selectedIndex,
    //     selectedItemColor: primaryColor,
    //     onTap: _onItemTapped,
    //   ),   
    // );
  }
}