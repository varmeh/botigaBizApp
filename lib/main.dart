import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'util/index.dart' show Flavor;
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

  await Firebase.initializeApp();

  await Flavor.shared.init();

  // Pass all uncaught errors to Crashlytics.
  if (kReleaseMode) {
    // Enable crashlytics only in release mode
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      // Forward to original handler.
      originalOnError(errorDetails);
    };
  }

  runApp(BotigaBizApp());
}

class BotigaBizApp extends StatelessWidget {
  // This widget is the root of your application.
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

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
      navigatorObservers: <NavigatorObserver>[observer],
    );
  }
}
