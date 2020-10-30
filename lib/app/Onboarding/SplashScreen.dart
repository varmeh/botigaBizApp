import 'package:botiga_biz/theme/index.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../util/index.dart' show Http;
import '../Onboarding/Onboarding.dart';
import '../Auth/Login/Login.dart';
import '../Home/HomeScreen.dart';
import '../../providers/Profile/ProfileProvider.dart';

class SplashScreen extends StatefulWidget {
  static final route = 'splashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener(loadNextScreen);
  }

  @override
  void dispose() {
    _controller.removeStatusListener(loadNextScreen);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Provider.of<ProfileProvider>(context, listen: false).fetchProfile(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            _animationCompleted) {
          String next;
          if (snapshot.hasError) {
            next = Http.tokenExists ? Login.routeName : IntroScreen.routeName;
          } else {
            next = HomeScreen.routeName;
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
      },
    );
  }

  void loadNextScreen(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      setState(() {
        _animationCompleted = true;
      });
    }
  }
}
