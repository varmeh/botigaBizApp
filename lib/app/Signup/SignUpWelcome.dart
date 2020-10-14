import 'package:flutter/material.dart';
import 'SignupVerifyOtp.dart';
import '../Auth/widgets/phoneScreen.dart';

class SignupWelcome extends StatelessWidget {
  static const routeName = '/signup-welcome';

  @override
  Widget build(BuildContext context) {
    return PhoneScreen(
      title: 'Welcome to Botiga',
      navigate: (phone) {
        Navigator.of(context)
            .pushNamed(SignUpOtp.routeName, arguments: {'phone': phone});
      },
    );
  }
}
