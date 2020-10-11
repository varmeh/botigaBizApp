import 'dart:io';
import 'package:provider/provider.dart';
import 'package:botiga_biz/util/index.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../theme/index.dart';
import '../../util/index.dart' show FlavorBanner;
import '../../app/Orders/OrdersHome.dart';
import '../../app/Store/StoreScreen.dart';
import "../profile-screen/profile.dart";
import '../../app/Delivery/deliveryScreen.dart';
import '../../providers/Store/Category/CategoryProvider.dart';

class Home extends StatefulWidget {
  static const routeName = '/home-screen';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  bool _isInit = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      preFetchData();
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  void preFetchData() {
    Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      {
        'page': OrdersHome(),
        'title': 'Orders',
      },
      {
        'page': StoreScreen(),
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            elevation: 0,
            backgroundColor: _selectedPageIndex == 0
                ? AppTheme.primaryColor
                : AppTheme.surfaceColor, // status bar color
            brightness: Brightness.light, // status bar brightness
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
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
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: const Icon(BotigaIcons.store),
                label: 'Store',
              ),
              BottomNavigationBarItem(
                icon: const Icon(BotigaIcons.package),
                label: 'Delivery',
              ),
              BottomNavigationBarItem(
                icon: const Icon(BotigaIcons.profile),
                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
