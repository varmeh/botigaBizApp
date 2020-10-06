import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

enum _Flavor { dev, prod }

class Flavor {
  static final Flavor _singleton = Flavor._internal();
  static Flavor get shared => _singleton;

  _Flavor _flavor;

  factory Flavor() => _singleton;

  Flavor._internal();

  Future<void> init() async {
    if (_flavor == null) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      switch (packageInfo.packageName) {
        case "app.botiga.botiga.biz.dev":
          _flavor = _Flavor.dev;
          break;

        default:
          _flavor = _Flavor.prod;
      }
    }
  }

  bool get isProduction => _flavor == _Flavor.prod;

  Color get bannerColor => isProduction ? Colors.transparent : Colors.brown;

  String get bannerName => isProduction ? 'PROD' : 'DEV';

  // String get baseUrl => isProduction
  //     ? 'http://production.url'
  //     : 'https://b5fcdfb2-e6be-4d97-b3bc-64ae4f03983a.mock.pstmn.io';

  String get baseUrl =>
      'https://b5fcdfb2-e6be-4d97-b3bc-64ae4f03983a.mock.pstmn.io';
}
