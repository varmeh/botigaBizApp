import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app/auth/index.dart'
    show
        Welcome,
        SignupBuissnessDetails,
        SignUpStoreDetails,
        VerifyOtp,
        SignUpBankeDetails;
import 'app/delivery/index.dart' show DeliveryScreen;
import 'app/home/index.dart' show HomeScreen;
import 'app/onboarding/index.dart' show SplashScreen, IntroScreen;
import 'app/orders/index.dart' show OrderDetails, OrdersHome, OrderList;
import 'app/profile/index.dart'
    show SelectArea, BussinessDetails, StoreDeatils, BankDetails, FssaiDetails;
import 'app/store/index.dart' show StoreScreen, AddProduct, EditProduct;
import 'providers/index.dart'
    show
        OrdersProvider,
        CategoryProvider,
        ProductProvider,
        ProfileProvider,
        ServicesProvider,
        DeliveryProvider;
import 'util/index.dart' show Flavor, Http, KeyStore;

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

  //FirebaseCrashlytics for release mode
  if (kReleaseMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
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
        ChangeNotifierProvider(
          create: (_) => DeliveryProvider(),
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
        BankDetails.routeName: (ctx) => BankDetails(),
        DeliveryScreen.routeName: (ctx) => DeliveryScreen(),
        Welcome.routeName: (ctx) => Welcome(),
        VerifyOtp.routeName: (ctx) => VerifyOtp(),
        SignupBuissnessDetails.routeName: (ctx) => SignupBuissnessDetails(),
        SignUpStoreDetails.routeName: (ctx) => SignUpStoreDetails(),
        SignUpBankeDetails.routeName: (ctx) => SignUpBankeDetails(),
        FssaiDetails.routeName: (ctx) => FssaiDetails(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => null,
        );
      },
    );
  }
}
