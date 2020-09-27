import 'package:flutter/material.dart';
import 'lightTheme.dart';

final _textThemeUpdate = TextTheme(
  headline: TextStyle(fontWeight: FontWeight.bold),
  subtitle: TextStyle(fontWeight: FontWeight.w500),
);

final _selectedIconTheme = IconThemeData(size: 40);
final _unselectedIconTheme = IconThemeData(size: 30);

class AppTheme {
  static final light = lightTheme.copyWith(
    disabledColor: Colors.grey[300],
    textTheme: lightTheme.textTheme.merge(_textThemeUpdate),
    cardTheme: CardTheme(
      margin: EdgeInsets.only(top: 10.0, left: 8.0, right: 8.0),
    ),
    // bottomAppBarTheme: lightTheme.bottomAppBarColor.(
    //   selectedIconTheme: _selectedIconTheme,
    //   unselectedIconTheme: _unselectedIconTheme,
    // ),
  );
}
