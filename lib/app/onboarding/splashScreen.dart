import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../providers/index.dart' show ProfileProvider;
import '../../theme/index.dart';
import '../../util/index.dart' show KeyStore, Http;
import '../auth/index.dart' show Welcome;
import '../home/index.dart' show HomeScreen;
import 'index.dart' show IntroScreen;

class SplashScreen extends StatefulWidget {
  static final routeName = 'splashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool _isProfileFetchComplete = false;
  Exception _error;

  AnimationController _controller;
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener(loadNextScreen);

    Future.delayed(Duration(milliseconds: 200), () => _getSellerProfile());
  }

  @override
  void dispose() {
    _controller.removeStatusListener(loadNextScreen);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isProfileFetchComplete && _animationCompleted) {
      String next;
      if (KeyStore.firstRun()) {
        next = IntroScreen.routeName;
      } else {
        next = _error != null ? Welcome.routeName : HomeScreen.routeName;
      }
      Future.delayed(Duration.zero,
          () => Navigator.of(context).pushReplacementNamed(next));
    }

    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Lottie.asset(
          'assets/lotties/splashScreen.json',
          repeat: false,
          fit: BoxFit.fill,
          controller: _controller,
          onLoaded: (composition) {
            // Configure the AnimationController with the duration of the
            // Lottie file and start the animation.

            _controller.duration = composition.duration;
            _controller.reset();
            _controller.forward();
          },
        ),
      ),
    );
  }

  void _getSellerProfile() async {
    try {
      if (Http.tokenNotExists) {
        await Http.fetchToken();
      }
      await Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
    } catch (error) {
      _error = error;
    } finally {
      setState(() {
        _isProfileFetchComplete = true;
      });
    }
  }

  void loadNextScreen(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _animationCompleted = true;
      });
    }
  }
}
