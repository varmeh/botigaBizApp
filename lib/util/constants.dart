import 'package:flutter/material.dart';

class Constants {
  // TextStyle Constants
  static const kTextStyleFontWeight300 = TextStyle(fontWeight: FontWeight.w300);
  static const kTextStyleFontWeight600 = TextStyle(fontWeight: FontWeight.w600);
  static const kTextStyleFontWeight700 = TextStyle(fontWeight: FontWeight.w700);

  // EdgeInsets
  static const kEdgeInsetsCard = EdgeInsets.only(
    top: 25.0,
    left: 15.0,
    right: 15.0,
    bottom: 10.0,
  );

  //Order String Constants
  static const rupeeSymbol = '\u20B9';
  static const viewAllOrders = 'See all orders';
  static const revenue = 'REVENUE';
  static const orders = 'ORDERS';

  //Seller related to api call
  static const SELLER_BASE_URL = '/api/seller/';
  static const String AGGREGATED_ORDERS_INFORMATION =
      '$SELLER_BASE_URL/orders/aggregate/2020-09-30';
  static const String ORDER_BYDATE_APARTMENT =
      '$SELLER_BASE_URL/orders/5f5a35d281710e963e530a5b/2020-09-30';
}
