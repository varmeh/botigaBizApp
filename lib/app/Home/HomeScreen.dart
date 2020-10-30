import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../theme/index.dart';
import '../../util/index.dart' show FlavorBanner, Http;
import '../Orders/OrdersHome.dart';
import '../Store/StoreScreen.dart';
import '../Profile/ProfileScreen.dart';
import '../Delivery/deliveryScreen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _pages = [
    OrdersHome(),
    StoreScreen(),
    DeliveryScreen(),
    ProfileScreen(),
  ];

  int _selectedPageIndex = 0;
  FirebaseMessaging _fbm;

  @override
  void initState() {
    super.initState();

    // Configure Firebase Messaging
    _fbm = FirebaseMessaging();

    // Request for permission on notification on Ios device
    if (Platform.isIOS) {
      _fbm.onIosSettingsRegistered.listen((data) {
        _saveToken();
      });
      Future.delayed(
        Duration(seconds: 1),
        () => _fbm
            .requestNotificationPermissions(), //Delay request to ensure screen loading
      );
    } else {
      _saveToken();
    }

    _fbm.configure(
      onMessage: (Map<String, dynamic> message) async {},
      onLaunch: (Map<String, dynamic> message) async {},
      onResume: (Map<String, dynamic> message) async {},
    );
  }

  void _selectPage(int index) {
    setState(() => _selectedPageIndex = index);
    setStatusBarBrightness();
  }

  void setStatusBarBrightness() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness:
          _selectedPageIndex == 0 ? Brightness.dark : Brightness.light,
    ));
  }

  void _saveToken() async {
    final token = await _fbm.getToken();
    try {
      await Http.patch('/api/seller/auth/token', body: {'token': token});
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: _pages[_selectedPageIndex],
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
            backgroundColor: AppTheme.backgroundColor,
            selectedIconTheme: IconThemeData(size: 28),
            selectedItemColor: AppTheme.primaryColor,
            selectedLabelStyle: AppTheme.textStyle.w500.size(12),
            unselectedLabelStyle: AppTheme.textStyle.w500.size(13),
            unselectedItemColor: AppTheme.navigationItemColor,
            type: BottomNavigationBarType.fixed,
            onTap: _selectPage,
            currentIndex: _selectedPageIndex,
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
