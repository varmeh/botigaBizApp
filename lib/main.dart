import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'theme/appTheme.dart';
import 'app/tabbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restricting Orientation to Portrait Mode only
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(BotigaBizApp());
}

class BotigaBizApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      title: 'Botiga Business',
      theme: AppTheme.light,
      initialRoute: Tabbar.route,
      routes: {
        Tabbar.route: (context) => Tabbar(),
      },
    );
  }
}
