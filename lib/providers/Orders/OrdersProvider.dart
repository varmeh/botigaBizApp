import 'package:flutter/foundation.dart';
import '../../models/Orders/AggregatedOrders.dart';
import '../../models/Orders/OrderByDateDetail.dart';
import '../../util/constants.dart';
import '../../util/index.dart' show Http;

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
      final response = await Http.get('/api/seller/orders/aggregate/$date');
      this._aggregatedOrders = AggregatedOrders.fromJson(response);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchOrderByDateApartment(
      String apartmentId, String date) async {
    try {
      final response = await Http.get(
          '/api/seller/orders/$apartmentId/$date?limit=100&page=1');
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
      return Http.patch('/api/seller/orders/delivery/delayed',
          body: {"orderId": orderId, "newDate": newDate});
    } catch (error) {
      throw (error);
    }
  }

  Future setDeliveryStatus(String orderId) async {
    try {
      return Http.patch('/api/seller/orders/delivery/status',
          body: {"orderId": orderId, "status": "delivered"});
    } catch (error) {
      throw (error);
    }
  }

  Future cancelOrder(String orderId) async {
    try {
      return Http.post('/api/seller/orders/cancel', body: {"orderId": orderId});
    } catch (error) {
      throw (error);
    }
  }
}
