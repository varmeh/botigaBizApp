import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show ProfileProvider;
import '../../theme/index.dart';
import '../../util/index.dart' show FlavorBanner, Http, KeyStore;
import '../../widget/index.dart' show Loader, HttpExceptionWidget;
import '../delivery/index.dart' show DeliveryScreen;
import '../orders/index.dart' show OrdersHome;
import '../profile/index.dart' show ProfileScreen;
import '../store/index.dart' show StoreScreen;

class HomeScreen extends StatefulWidget {
  static const routeName = 'home-screen';

  final int index;

  HomeScreen({this.index});

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

  int _selectedPageIndex;
  FirebaseMessaging _fbm;
  bool _isLoading = false;
  bool _isError = false;
  var _error;

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

    _selectedPageIndex = widget.index ?? 0;
    _initializeHome();
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
    final resetToken = await KeyStore.shared.resetToken();
    if (resetToken) {
      final token = await _fbm.getToken();
      try {
        await Http.patch('/api/seller/auth/token', body: {'token': token});
      } catch (_) {}
    }
  }

  void _initializeHome() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    if (!profileProvider.hasProfile) {
      setState(() {
        _isLoading = true;
        _isError = false;
        _error = null;
      });
      try {
        await profileProvider.fetchProfile();
      } catch (err) {
        setState(() {
          _isError = true;
          _error = err;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlavorBanner(
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: _isLoading
            ? Loader()
            : _isError
                ? HttpExceptionWidget(
                    exception: _error,
                    onTap: () {
                      _initializeHome();
                    },
                  )
                : _pages[_selectedPageIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: AppTheme.color25, blurRadius: 20)]),
          child: (!_isLoading && !_isError)
              ? BottomNavigationBar(
                  backgroundColor: AppTheme.backgroundColor,
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
                      label: 'Profile',
                    ),
                  ],
                )
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}
