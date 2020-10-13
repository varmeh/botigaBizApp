import 'package:flutter/foundation.dart';
import '../../util/constants.dart';
import '../../util/network/index.dart' show HttpService;
import '../../models/Profile/BusinessDetails/BusinessDetails.dart';
import 'dart:convert';

class BusinessProvider with ChangeNotifier {
  BusinessDetails _businessDetails;

  get businessDetails {
    return this._businessDetails;
  }

  Future<void> fetchBusinessDetails() async {
    try {
      final response =
          await HttpService().get('${Constants.GET_BUSINESS_DETAILS}');
      _businessDetails = response;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future updateBusinessInfromation(String brandName, String tagline,
      String imageUrl, String businessCategory) async {
    try {
      final body = json.encode({
        "brandName": brandName,
        "tagline": tagline,
        "imageUrl": "https://s3.com/durl"
      });
      return HttpService()
          .patch('${Constants.UPDATE_BUSINESS_INFROMATION}', body);
    } catch (error) {
      throw (error);
    }
  }
}
