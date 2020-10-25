import 'package:botiga_biz/widget/index.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:botiga_biz/app/Onboarding/Onboarding.dart';
import '../Auth/Login/Login.dart';
import '../Auth/Signup/SignUpWelcome.dart';
import '../Home/HomeScreen.dart';
import '../../util/index.dart';
import '../../providers/Auth/AuthProvider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _isInit;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isInit = false;
    _isLoading = false;
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      final secureStorage = SecureStorage();
      secureStorage.getAuthToken().then((value) {
        print("---->>>>$value");
        if (value == null) {
          secureStorage.getIntroStatusCompleted().then((value) {
            setState(() {
              _isLoading = false;
            });
            if (value == 'done') {
              Navigator.pushReplacementNamed(
                context,
                SignupWelcome.routeName,
              );
            } else {
              Navigator.pushReplacementNamed(
                context,
                IntroScreen.routeName,
              );
            }
          }).catchError((error) {
            setState(() {
              _isLoading = false;
            });
            Navigator.pushReplacementNamed(
              context,
              IntroScreen.routeName,
            );
          });
        } else {
          final authProvider =
              Provider.of<AuthProvider>(context, listen: false);
          authProvider.validateToken().then((value) {
            setState(() {
              _isLoading = false;
            });
            Navigator.pushReplacementNamed(
              context,
              HomeScreen.routeName,
            );
          }).catchError((err) {
            print("---->>>>$err");
            setState(() {
              _isLoading = false;
            });
            Navigator.pushReplacementNamed(
              context,
              Login.routeName,
            );
          });
        }
      }).catchError((err) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacementNamed(
          context,
          Login.routeName,
        );
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    const sizedBox = SizedBox(height: 24);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lotties/fish.json',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
            sizedBox,
            _isLoading ? Loader() : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
