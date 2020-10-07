import 'package:flutter/foundation.dart';
import '../../util/constants.dart';
import '../../util/network/index.dart' show HttpService;
import '../../models/Delivery/DeliveryByDateDetails.dart';

class DeliveryProvider with ChangeNotifier {
  List<DeliveryByDateDetails> _deliveryByDateDetails;

  get deliveryByDateDetails {
    return this._deliveryByDateDetails;
  }

  Future<void> fetchDeliveryByDateDeatils() async {
    try {
      final response = await HttpService().get('${Constants.DELIVERY_BY_DATE}');
      List<DeliveryByDateDetails> items = [];
      for (var delivery in response) {
        items.add(DeliveryByDateDetails.fromJson(delivery));
      }
      _deliveryByDateDetails = items;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
