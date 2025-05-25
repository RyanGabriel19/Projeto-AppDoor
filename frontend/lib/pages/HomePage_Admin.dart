import 'package:flutter/material.dart';
import 'telaCrud.dart';
import 'telaControle.dart';
import 'telaConfig.dart';

class HomePage_admin extends StatefulWidget {
  @override
  _HomePage_AdminState createState() => _HomePage_AdminState();
}

class _HomePage_AdminState extends State<HomePage_admin> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [telaControle(), telaCrud(), telaConfig()];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Controle',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Funções'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
