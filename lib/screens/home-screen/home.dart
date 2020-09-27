import 'package:flutter/material.dart';
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
          backgroundColor: Theme.of(context).bottomAppBarColor,
          unselectedItemColor: Colors.black,
          selectedItemColor: Theme.of(context).accentColor,
          currentIndex: _selectedPageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Tab(
                icon: Image.asset("assets/icons/orders.png"),
              ),
              title: Text(
                'Orders',
              ),
            ),
            BottomNavigationBarItem(
              icon: Tab(
                icon: Image.asset("assets/icons/store.png"),
              ),
              title: Text(
                'Store',
              ),
            ),
            BottomNavigationBarItem(
              icon: Tab(icon: Icon(Icons.ac_unit)),
              title: Text(
                'Delivery',
              ),
            ),
            BottomNavigationBarItem(
              icon: Tab(
                icon: Image.asset("assets/icons/profile.png"),
              ),
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
