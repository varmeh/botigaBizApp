import 'package:flutter/material.dart';

import '../theme/index.dart';

class FullWidthButton extends StatelessWidget {
  final String title;
  final Function onPressed;

  FullWidthButton({@required this.title, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(8.0),
          ),
          backgroundColor: AppTheme.primaryColor,
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            title,
            style: AppTheme.textStyle.w600
                .size(15.0)
                .lineHeight(1.5)
                .colored(AppTheme.backgroundColor),
          ),
        ),
      ),
    );
  }
}
