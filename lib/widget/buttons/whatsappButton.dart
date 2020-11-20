import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/index.dart';
import 'passiveButton.dart';
import '../toast.dart';

class WhatsappButton extends StatelessWidget {
  final String number;
  final String title;
  final String message;
  final double width;

  WhatsappButton({
    @required this.number,
    this.title = 'Whatsapp',
    this.message = '',
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return PassiveButton(
      height: 44,
      width: width,
      icon: Image.asset(
        'assets/images/watsapp.png',
        width: 18,
        height: 18,
      ),
      onPressed: () => _whatsapp(context),
      title: title,
    );
  }

  void _whatsapp(BuildContext context) async {
    String url =
        'whatsapp://send?phone=91$number&text=${Uri.encodeComponent(message)}';
    if (await canLaunch(url)) {
      Future.delayed(Duration(milliseconds: 300), () async {
        await launch(url);
      });
    } else {
      Toast(
        message: 'Please download whatsapp to use this feature',
        icon: Image.asset(
          'assets/images/watsapp.png',
          width: 28.0,
          height: 28.0,
          color: AppTheme.backgroundColor,
        ),
      ).show(context);
    }
  }
}
