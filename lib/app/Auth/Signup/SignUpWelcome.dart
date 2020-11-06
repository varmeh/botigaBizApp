import 'package:flutter/material.dart';
import 'signupVerifyOtp.dart';
import '../widgets/phoneScreen.dart';

class SignupWelcome extends StatelessWidget {
  static const routeName = 'signup-welcome';

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
