import 'package:flutter/foundation.dart';
import '../../models/Orders/AggregatedOrders.dart';
import '../../models/Orders/OrderByDateDetail.dart';
import '../../util/constants.dart';
import '../../util/network/index.dart' show HttpService;
import 'dart:convert';

class OrdersProvider with ChangeNotifier {
  AggregatedOrders _aggregatedOrders;
  List<OrderByDateDetail> _orderByDateApartment;

  get aggregatedOrders {
    return this._aggregatedOrders;
  }

  get orderByDateApartment {
    return this._orderByDateApartment;
  }

  OrderByDateDetail getOrderDetails(String id) {
    return orderByDateApartment
        .where((orderEl) => orderEl.id == id)
        .toList()
        .first;
  }

  Future<void> fetchAggregatedOrders(String date) async {
    try {
      //TODO: check date returns 404
      final response = await HttpService()
          .get('${Constants.AGGREGATED_ORDERS_INFORMATION}/2020-09-09');
      this._aggregatedOrders = AggregatedOrders.fromJson(response);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchOrderByDateApartment(
      String apartmentId, String date) async {
    try {
      //TODO: Check date returns 404
      //TODO: Replace with actual apartmentId
      //TODO: Actual date
      final response = await HttpService().get(
          '${Constants.ORDER_BYDATE_APARTMENT}/5f75dce36495931a756da594/2020-10-17?limit=100&page=1');
      List<OrderByDateDetail> items = [];
      for (var order in response['orders']) {
        items.add(OrderByDateDetail.fromJson(order));
      }
      _orderByDateApartment = items;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future setDeliveryDelayed(String orderId, String newDate) async {
    try {
      final body = json.encode({"orderId": orderId, "newDate": newDate});
      return HttpService().patch('${Constants.DELIVERY_DELAYED}', body);
    } catch (error) {
      throw (error);
    }
  }

  Future setDeliveryStatus(String orderId) async {
    try {
      final body = json.encode({"orderId": orderId, "status": "delivered"});
      return HttpService()
          .patch('${Constants.ORDER_DELIVERY_STATUS_SET}', body);
    } catch (error) {
      throw (error);
    }
  }

  Future cancelOrder(String orderId) async {
    try {
      final body = json.encode({"orderId": orderId});
      return HttpService().post('${Constants.CANCEL_ORDER}', body);
    } catch (error) {
      throw (error);
    }
  }
}
