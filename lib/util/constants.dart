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
  static const revenue = 'REVENUE';
  static const orders = 'ORDERS';
  static const today = 'TODAY';
  static const deliveryDateChanged = 'Delivery date changed to';
  static const expectedDelivery = 'Expected delivery';
  static const deliverdOn = 'Delivered on';

  //STORE SCREEN CONSTANTS
  static const ADD_PRODUCT_BTN = 'ADD PRODUCT';
  static const ADD_CATEGORY_BTN = 'ADD CATEGORY';
  static const STORE_TABS = ['Products', 'Categories'];

  //SELLER BASE URL
  static const SELLER_BASE_URL = '/api/seller/';

  //ORDER
  static const String AGGREGATED_ORDERS_INFORMATION =
      '$SELLER_BASE_URL/orders/aggregate';

  static const String ORDER_BYDATE_APARTMENT = '$SELLER_BASE_URL/orders';

  static const String DELIVERY_DELAYED =
      '$SELLER_BASE_URL/orders/delivery/delayed';

  static const String ORDER_DELIVERY_STATUS_SET =
      '$SELLER_BASE_URL/orders/delivery/status';

  static const String CANCEL_ORDER = '$SELLER_BASE_URL/orders/cancel';

  //DELIVERY
  static const String DELIVERY_BY_DATE =
      '$SELLER_BASE_URL/orders/delivery/5f5a35d281710e963e530a5b/2020-10-01';

  //APARTMENT
  static const String GET_APARTMENT = '$SELLER_BASE_URL/apartments';

  //CATEGORY
  static const String GET_ALL_CATEGORY = '$SELLER_BASE_URL/categories';
  static const String DELETE_CATEGORY = '$SELLER_BASE_URL/categories';

  //PRODUCTS
  static const String GET_ALL_PRODUCTS = '$SELLER_BASE_URL/products';
}
