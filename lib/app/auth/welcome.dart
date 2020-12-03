import 'package:flutter/material.dart';
import 'index.dart' show VerifyOtp;
import 'widgets/index.dart' show PhoneScreen;
import '../../util/index.dart' show KeyStore;

class Welcome extends StatelessWidget {
  static const routeName = 'signup-welcome';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragDown: (_) => FocusScope.of(context).unfocus(),
      child: PhoneScreen(
        title: KeyStore.firstRun() ? 'Welcome to Botiga' : 'Login',
        navigate: (phone) {
          Navigator.of(context)
              .pushNamed(VerifyOtp.routeName, arguments: {'phone': phone});
        },
      ),
    );
  }
}
