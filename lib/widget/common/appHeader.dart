import 'package:botiga_biz/theme/index.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final Widget actionWidget;

  AppHeader({@required this.title, @required this.actionWidget});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                child: Icon(BotigaIcons.arrowBack),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Text(
              '$title',
              style: TextStyle(
                color: Color(0xff121715),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actionWidget,
      ],
    );
  }
}
