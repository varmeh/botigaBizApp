import 'package:flutter/material.dart';

import '../util/index.dart' show FlavorBanner;

class Tabbar extends StatefulWidget {
  static String route = 'tabbar';

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  int _selectedIndex = 0;

  static Widget _screen(String name, Color color) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          name,
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static List<Widget> _selectedTab = [
    _screen('Order', Colors.lightBlue[50]),
    _screen('Delivery', Colors.lightGreen[50]),
    _screen('Catalog', Colors.orange[50]),
    _screen('Botiga', Colors.pink[50]),
  ];

  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Botiga Business'),
        ),
        body: SafeArea(
          child: _selectedTab.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: const Icon(Icons.attach_money),
              title: const Text('Orders'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.motorcycle),
              title: const Text('Delivery'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.add_shopping_cart),
              title: const Text('Catalog'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.store),
              title: const Text('Botiga'),
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
