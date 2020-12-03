import 'package:flutter/foundation.dart';

import '../models/orders/index.dart';
import '../util/index.dart' show Http, DateFormatter;

class DeliveryProvider with ChangeNotifier {
  List<OrderByDateDetail> _deliveryListByApartmentOtherDay = [];
  Map<String, List<OrderByDateDetail>> _deliveryByApartmentToday = Map();

  get deliveryListByApartmentOtherDay {
    return this._deliveryListByApartmentOtherDay;
  }

  get deliveryByApartmentToday {
    return this._deliveryByApartmentToday;
  }

  OrderByDateDetail getDeliveryDetails(
      String id, String apartmentId, String date) {
    final todaysDate = DateTime.now().getRequestFormatDate();
    if (date == todaysDate) {
      return _deliveryByApartmentToday['$apartmentId-$date']
          .firstWhere((deliveryEl) => deliveryEl.id == id, orElse: () => null);
    }
    return _deliveryListByApartmentOtherDay
        .firstWhere((deliveryEl) => deliveryEl.id == id, orElse: () => null);
  }

  Future<void> fetchDeliveryListByApartment(
      String apartmentId, String date) async {
    final todaysDate = DateTime.now().getRequestFormatDate();
    final response = await Http.get(
        '/api/seller/delivery/$apartmentId/$date?limit=25&page=1');
    List<OrderByDateDetail> items = [];
    for (var order in response['deliveries']) {
      items.add(OrderByDateDetail.fromJson(order));
    }
    _deliveryListByApartmentOtherDay = items;
    if (date == todaysDate) {
      _deliveryByApartmentToday['$apartmentId-$date'] = items;
    }
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

  Future resetDelivery() async {
    this._deliveryListByApartmentOtherDay = [];
    this._deliveryByApartmentToday = Map();
    notifyListeners();
  }
}
