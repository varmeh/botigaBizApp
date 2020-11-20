import 'package:flutter/material.dart';
import 'package:app_settings/app_settings.dart';

import '../theme/index.dart';

class SettingsDiaglog {
  void show(BuildContext context, String feature) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Access Denied',
          style: AppTheme.textStyle.w500.color100,
        ),
        content: Text(
          'To access $feature, enable it in your app settings',
          style: AppTheme.textStyle.w400.color100,
        ),
        actions: [
          FlatButton(
            child: Text(
              'Cancel',
              style: AppTheme.textStyle.w600.color50,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              'Settings',
              style: AppTheme.textStyle.w600.colored(AppTheme.primaryColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              AppSettings.openAppSettings();
            },
          ),
        ],
      ),
    );
  }
}
