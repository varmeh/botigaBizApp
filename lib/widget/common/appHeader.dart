import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final Widget actionWidget;
  final bool showBackBtn;

  AppHeader(
      {@required this.title,
      @required this.actionWidget,
      this.showBackBtn = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            this.showBackBtn
                ? InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Icon(BotigaIcons.arrowBack),
                    ),
                  )
                : SizedBox.shrink(),
            this.showBackBtn
                ? SizedBox(
                    width: 16,
                  )
                : SizedBox.shrink(),
            Text(
              '$title',
              style: TextStyle(
                  color: Color(0xff121715),
                  fontSize: 22,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actionWidget,
      ],
    );
  }
}

class LoginSignupHeader extends StatelessWidget {
  final String title;
  final Widget actionWidget;
  final bool showBackBtn;

  LoginSignupHeader(
      {@required this.title,
      @required this.actionWidget,
      this.showBackBtn = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            this.showBackBtn
                ? InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Icon(BotigaIcons.arrowBack),
                    ),
                  )
                : SizedBox.shrink(),
            this.showBackBtn
                ? SizedBox(
                    width: 16,
                  )
                : SizedBox.shrink(),
            Text(
              '$title',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 28,
                  color: Color(0xffFFFFFF)),
            ),
          ],
        ),
        actionWidget,
      ],
    );
  }
}
