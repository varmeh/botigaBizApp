import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'util/index.dart' show Flavor, Http;

import 'app/Home/homeScreen.dart';
import 'app/Orders/orderList.dart';
import 'app/Orders/ordersHome.dart';
import 'app/Orders/orderDetails.dart';
import 'app/Orders/orderDelivery.dart';
import 'app/Store/storeScreen.dart';
import 'app/Store/Product/addProduct.dart';
import 'app/Store/Product/editProduct.dart';
import 'app/Profile/Communites/selectArea.dart';
import 'app/Profile/Profile/bussinessDetails.dart';
import 'app/Profile/Profile/storeDetails.dart';
import 'app/Delivery/deliveryScreen.dart';
import 'app/Auth/Signup/signUpWelcome.dart';
import 'app/Auth/Signup/signupVerifyOtp.dart';
import 'app/Auth/Signup/signupBussinessDetails.dart';
import 'app/Auth/Signup/signupStoreDetails.dart';
import 'app/Auth/Signup/setPin.dart';
import 'app/Auth/Login/login.dart';
import 'app/Auth/Login/forgotPin.dart';
import 'app/Auth/Login/enterPin.dart';
import 'app/Onboarding/onboarding.dart';
import 'app/Onboarding/splashScreen.dart';
import 'package:provider/provider.dart';
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
        OrderDelivery.routeName: (ctx) => OrderDelivery(),
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
