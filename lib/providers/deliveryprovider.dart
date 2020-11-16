import 'package:flutter/foundation.dart';
import '../models/orders/index.dart';
import '../util/index.dart' show Http;

class DeliveryProvider with ChangeNotifier {
  List<OrderByDateDetail> _deliveryListByApartment = [];

  get deliveryListByApartment {
    return this._deliveryListByApartment;
  }

  OrderByDateDetail getDeliveryDetails(String id) {
    return deliveryListByApartment
        .firstWhere((deliveryEl) => deliveryEl.id == id, orElse: () => null);
  }

  Future<void> fetchDeliveryListByApartment(
      String apartmentId, String date) async {
    final response = await Http.get(
        '/api/seller/delivery/$apartmentId/$date?limit=25&page=1');
    List<OrderByDateDetail> items = [];
    for (var order in response['deliveries']) {
      items.add(OrderByDateDetail.fromJson(order));
    }
    _deliveryListByApartment = items;
    notifyListeners();
  }

  Future setDeliveryDelayed(String orderId, String newDate) async {
    return Http.patch('/api/seller/delivery/delayed',
        body: {'orderId': orderId, 'newDate': newDate});
  }

  Future setDeliveryStatus(String orderId) async {
    return Http.patch('/api/seller/delivery/status',
        body: {'orderId': orderId, 'status': 'delivered'});
  }

  Future setStatusOutForDelivery(String orderId) async {
    return Http.patch('/api/seller/delivery/status',
        body: {'orderId': orderId, 'status': 'out'});
  }

  Future resetOrder() async {
    this._deliveryListByApartment = [];
    notifyListeners();
  }
}
