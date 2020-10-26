import 'package:flutter/foundation.dart';
import '../../util/constants.dart';
import '../../util/network/index.dart' show HttpService;
import '../../models/Profile/StoreDetails/StoreDetails.dart';
import 'dart:convert';

class StoreProvider with ChangeNotifier {
  StoreDetails _storeDetails;

  get storeDetails {
    return this._storeDetails;
  }

  Future<void> fetchStoreDetails() async {
    try {
      final response =
          await HttpService().get('${Constants.GET_STORE_DETAILS}');
      _storeDetails = response;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future updateStoreDetails(
      String phone,
      String whatsapp,
      String email,
      String building,
      String street,
      String area,
      String city,
      String state,
      int pincode) async {
    try {
      final body = json.encode({
        "phone": phone,
        "email": email,
        "whatsapp": whatsapp,
        "address": {
          "building": building,
          "street": street,
          "area": area,
          "pincode": pincode,
          "city": city,
          "state": state
        }
      });
      return HttpService().patch('${Constants.UPDATE_STORE_DETAILS}', body);
    } catch (error) {
      throw (error);
    }
  }
}
