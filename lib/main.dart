import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'util/index.dart' show Flavor, Http, KeyStore;

import 'app/auth/index.dart'
    show
        //SignUp
        SignupWelcome,
        SignupBuissnessDetails,
        SignUpStoreDetails,
        SetPin,
        SignUpOtp,
        //Login
        Login,
        LoginForgotPin,
        EnterPin;
import 'app/home/index.dart' show HomeScreen;
import 'app/orders/index.dart' show OrderDetails, OrdersHome, OrderList;
import 'app/store/index.dart' show StoreScreen, AddProduct, EditProduct;
import 'app/profile/index.dart' show SelectArea, BussinessDetails, StoreDeatils;
import 'app/delivery/index.dart' show DeliveryScreen;
import 'app/onboarding/index.dart' show SplashScreen, IntroScreen;

import 'providers/index.dart'
    show
        OrdersProvider,
        CategoryProvider,
        ProductProvider,
        ProfileProvider,
        ServicesProvider;

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
  await Http.fetchToken();
  await KeyStore.initialize();

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    Function originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      originalOnError(errorDetails);
    };
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ServicesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrdersProvider(),
        ),
      ],
      child: BotigaBizApp(),
    ),
  );
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
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (ctx) => SplashScreen(),
        IntroScreen.routeName: (ctx) => IntroScreen(),
        Login.routeName: (ctx) => Login(),
        HomeScreen.routeName: (ctx) => HomeScreen(index: 0),
        OrdersHome.routeName: (ctx) => OrdersHome(),
        OrderList.routeName: (ctx) => OrderList(),
        OrderDetails.routeName: (ctx) => OrderDetails(),
        StoreScreen.routeName: (ctx) => StoreScreen(),
        AddProduct.routeName: (ctx) => AddProduct(),
        EditProduct.routeName: (ctx) => EditProduct(),
        SelectArea.routeName: (ctx) => SelectArea(),
        BussinessDetails.routeName: (ctx) => BussinessDetails(),
        StoreDeatils.routeName: (ctx) => StoreDeatils(),
        DeliveryScreen.routeName: (ctx) => DeliveryScreen(),
        SignupWelcome.routeName: (ctx) => SignupWelcome(),
        SignUpOtp.routeName: (ctx) => SignUpOtp(),
        SignupBuissnessDetails.routeName: (ctx) => SignupBuissnessDetails(),
        SignUpStoreDetails.routeName: (ctx) => SignUpStoreDetails(),
        SetPin.routeName: (ctx) => SetPin(),
        EnterPin.routeName: (ctx) => EnterPin(),
        LoginForgotPin.routeName: (ctx) => LoginForgotPin()
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => null,
        );
      },
    );
  }
}
