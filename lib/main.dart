import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'util/index.dart' show Flavor;

import 'app/Home/HomeScreen.dart';
import 'app/Orders/orderList.dart';
import 'app/Orders/OrdersHome.dart';
import 'app/Orders/orderDetails.dart';
import 'app/Orders/orderDelivery.dart';
import 'app/Orders/orderFinalResult.dart';
import 'app/Store/StoreScreen.dart';
import 'app/Store/Product/addProduct.dart';
import 'screens/communities-screen/selectArea.dart';
import 'screens/communities-screen/selectCommunites.dart';
import 'app/Profile/Profile/BussinessDetails.dart';
import 'app/Profile/Profile/StoreDetails.dart';
import 'app/Delivery/deliveryScreen.dart';
import 'app/Auth/Signup/SignUpWelcome.dart';
import 'app/Auth/Signup/SignupVerifyOtp.dart';
import 'app/Auth/Signup/SignupBussinessDetails.dart';
import 'app/Auth/Signup/SignupStoreDetails.dart';
import 'app/Auth/Signup/SetPin.dart';
import 'app/Auth/Signup/SetPinSuccess.dart';
import 'app/Auth/Login/Login.dart';
import 'app/Auth/Login/ForgotPin.dart';
import 'app/Auth/Login/EnterPin.dart';
import 'app/Onboarding/Onboarding.dart';
import 'package:provider/provider.dart';
import './providers/Orders/OrdersProvider.dart';
import './providers/Apartment/ApartmentProvide.dart';
import './providers/Store/Category/CategoryProvider.dart';
import './providers/Store/Product/ProductProvider.dart';
import './providers/Profile/StoreProvider.dart';
import './providers/Profile/BusinessProvider.dart';
import './providers/Auth/AuthProvider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BusinessProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoreProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ApartmentProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrdersProvider(),
        ),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        title: 'Botiga Business',
        home: IntroScreen(),
        routes: {
          Login.routeName: (ctx) => Login(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          OrdersHome.routeName: (ctx) => OrdersHome(),
          OrderList.routeName: (ctx) => OrderList(),
          OrderDetails.routeName: (ctx) => OrderDetails(),
          OrderDelivery.routeName: (ctx) => OrderDelivery(),
          OrderFinalResult.routeName: (ctx) => OrderFinalResult(),
          StoreScreen.routeName: (ctx) => StoreScreen(),
          AddProduct.routeName: (ctx) => AddProduct(),
          SelectArea.routeName: (ctx) => SelectArea(),
          SelectCommunites.routeName: (ctx) => SelectCommunites(),
          BussinessDetails.routeName: (ctx) => BussinessDetails(),
          StoreDeatils.routeName: (ctx) => StoreDeatils(),
          DeliveryScreen.routeName: (ctx) => DeliveryScreen(),
          SignupWelcome.routeName: (ctx) => SignupWelcome(),
          SignUpOtp.routeName: (ctx) => SignUpOtp(),
          SignupBuissnessDetails.routeName: (ctx) => SignupBuissnessDetails(),
          SignUpStoreDetails.routeName: (ctx) => SignUpStoreDetails(),
          SetPin.routeName: (ctx) => SetPin(),
          SetPinSuccess.routeName: (ctx) => SetPinSuccess(),
          EnterPin.routeName: (ctx) => EnterPin(),
          LoginForgotPin.routeName: (ctx) => LoginForgotPin()
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (ctx) => null,
          );
        },
        // navigatorObservers: <NavigatorObserver>[observer],
      ),
    );
  }
}
