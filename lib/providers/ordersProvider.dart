import 'package:flutter/foundation.dart';
import '../models/orders/index.dart';
import '../util/index.dart' show Http;

class OrdersProvider with ChangeNotifier {
  AggregatedOrders _aggregatedOrders;
  List<OrderByDateDetail> _orderByDateApartment = [];

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
    final response = await Http.get('/api/seller/orders/aggregate/$date');
    this._aggregatedOrders = AggregatedOrders.fromJson(response);
    notifyListeners();
  }

  Future<void> fetchOrderByDateApartment(
      String apartmentId, String date) async {
    final response = await Http.get(
        '/api/seller/orders/$apartmentId/$date?limit=100&page=1');
    List<OrderByDateDetail> items = [];
    for (var order in response['orders']) {
      items.add(OrderByDateDetail.fromJson(order));
    }
    _orderByDateApartment = items;
    notifyListeners();
  }

  Future cancelOrder(String orderId) async {
    return Http.post('/api/seller/orders/cancel', body: {'orderId': orderId});
  }

  Future setRefundCompleted(String orderId) async {
    return Http.patch('/api/seller/orders/refund/completed',
        body: {'orderId': orderId});
  }

  Future resetOrder() async {
    this._aggregatedOrders = null;
    this._orderByDateApartment = [];
    notifyListeners();
  }
}
