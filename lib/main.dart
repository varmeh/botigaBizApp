import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'util/index.dart' show Flavor;
import 'theme/appTheme.dart';
import 'screens/login-screen/login.dart';
import 'screens/home-screen/home.dart';
import 'screens/order-screen/orderList.dart';
import 'screens/order-screen/Order.dart';
import 'screens/order-details/orderDetails.dart';
import 'screens/order-delivery/orderDelivery.dart';
import 'screens/store-screen/store.dart';
import 'screens/add-product-screen/addProduct.dart';
import 'screens/add-product-success/addProductSuccess.dart';
import 'screens/communities-screen/selectArea.dart';
import 'screens/communities-screen/selectCommunites.dart';
import 'screens/bussiness-details-screen/addBussinessDetails.dart';
import 'screens/store-details-screen/storeDetails.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Restricting Orientation to Portrait Mode only
  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  await Flavor.shared.init();
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
      home: Login(),
      routes: {
        Home.routeName: (ctx) => Home(),
        Order.routeName: (ctx) => Order(),
        OrderList.routeName: (ctx) => OrderList(),
        OrderDetails.routeName: (ctx) => OrderDetails(),
        OrderDelivery.routeName: (ctx) => OrderDelivery(),
        Store.routeName: (ctx) => Store(),
        AddProduct.routeName: (ctx) => AddProduct(),
        AddProductSuccess.routeName: (ctx) => AddProductSuccess(),
        SelectArea.routeName: (ctx) => SelectArea(),
        SelectCommunites.routeName: (ctx) => SelectCommunites(),
        AddBussinessDetails.routeName: (ctx) => AddBussinessDetails(),
        AddStoreDeatils.routeName: (ctx) => AddStoreDeatils()
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (ctx) => null,
        );
      },
    );
  }
}
