import 'package:flutter/material.dart';
import 'enterPin.dart';
import '../widgets/phoneScreen.dart';

class Login extends StatelessWidget {
  static const routeName = 'login';

  @override
  Widget build(BuildContext context) {
    return PhoneScreen(
      title: 'Login',
      navigate: (phone) {
        Navigator.of(context)
            .pushNamed(EnterPin.routeName, arguments: {'phone': phone});
      },
    );
  }
}
