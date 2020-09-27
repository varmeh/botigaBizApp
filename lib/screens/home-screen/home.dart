import 'package:flutter/material.dart';
import '../../theme/index.dart' show BotigaIcons;
import '../order-screen/Order.dart';
import "../store-screen/store.dart";
import "../profile-screen/profile.dart";

class Home extends StatefulWidget {
  static const routeName = '/home-screen';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': Order(),
        'title': 'Orders',
      },
      {
        'page': Store(),
        'title': 'Store',
      },
      {
        'page': null,
        'title': 'Categories',
      },
      {
        'page': Profile(),
        'title': "Profile",
      }
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.black12,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(BotigaIcons.orders),
              title: Text(
                'Orders',
              ),
            ),
            BottomNavigationBarItem(
              icon: const Icon(BotigaIcons.store),
              title: Text(
                'Store',
              ),
            ),
            BottomNavigationBarItem(
              icon: const Icon(BotigaIcons.delivery),
              title: Text(
                'Delivery',
              ),
            ),
            BottomNavigationBarItem(
              icon: const Icon(BotigaIcons.profile),
              title: Text(
                "Profile",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
