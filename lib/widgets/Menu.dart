import 'package:flutter/material.dart';

import 'Handwriting.dart';
import 'SelectMode.dart';
import 'Settings.dart';

class Menu extends StatefulWidget {
  const Menu({super.key, required this.selectedIndex});

  final int selectedIndex;
  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  late int _selectedIndex = widget.selectedIndex;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static Map menu = {
    0: HandwritingWidget(),
    1: AIChat(),
    2: Settings()
  };

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      IndexedStack(
        children: <Widget>[
          HandwritingWidget(),
          AIChat(),
          Settings()
        ],
        index: _selectedIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.draw),
            label: 'Handwriting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}