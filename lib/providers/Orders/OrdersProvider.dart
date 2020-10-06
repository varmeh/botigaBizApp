import 'package:flutter/foundation.dart';
import '../../models/Orders/AggregatedOrders.dart';
import '../../models/Orders/OrderByDateDetail.dart';
import '../../util/constants.dart';
import '../../util/network/index.dart' show HttpService;

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

  Future<void> fetchAggregatedOrders() async {
    try {
      final response =
          await HttpService().get('${Constants.AGGREGATED_ORDERS_INFORMATION}');
      this._aggregatedOrders = AggregatedOrders.fromJson(response);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchOrderByDateApartment() async {
    try {
      final response =
          await HttpService().get('${Constants.ORDER_BYDATE_APARTMENT}');
      List<OrderByDateDetail> items = [];
      for (var order in response) {
        items.add(OrderByDateDetail.fromJson(order));
      }
      _orderByDateApartment = items;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
