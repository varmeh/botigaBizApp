import 'dart:io';
import 'package:botiga_biz/util/index.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../theme/index.dart' show BotigaIcons;
import '../../util/index.dart' show FlavorBanner;
import '../../app/Orders/OrdersHome.dart';
import "../store-screen/store.dart";
import "../profile-screen/profile.dart";
import '../../app/Delivery/deliveryScreen.dart';

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
    super.initState();
    _pages = [
      {
        'page': OrdersHome(),
        'title': 'Orders',
      },
      {
        'page': Store(),
        'title': 'Store',
      },
      {
        'page': DeliveryScreen(),
        'title': 'Categories',
      },
      {
        'page': Profile(),
        'title': "Profile",
      }
    ];

    final fbm = FirebaseMessaging();

    //Request for permission on notification on Ios device
    if (Platform.isIOS) {
      fbm.onIosSettingsRegistered.listen((data) {
        // save the token  OR subscribe to a topic here
      });
      fbm.requestNotificationPermissions();
    }

    fbm.getToken().then((value) => {
          //TODO: upload the push notification token to database
          print('Push Token: $value')
        });

    fbm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      child: Scaffold(
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
                icon: const Icon(BotigaIcons.package),
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
      ),
    );
  }
}
