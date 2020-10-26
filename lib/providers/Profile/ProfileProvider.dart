import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../../util/network/index.dart' show HttpService;
import '../../util/constants.dart';
import '../../models/Profile/Profile.dart';

class ProfileProvider with ChangeNotifier {
  Profile _profile;

  // get allAprtment {
  //   if (this._apartments != null && this._apartments.apartments.length > 0) {
  //     return this._apartments.apartments;
  //   }
  //   return [];
  // }

  // get defaultAppartment {
  //   if (this._apartments != null && this._apartments.apartments.length > 0) {
  //     return this._apartments.apartments.first;
  //   }
  //   return null;
  // }

  get profileInfo {
    return this._profile;
  }

  Future fetchProfile() async {
    try {
      final response = await HttpService().get('/api/seller/profile');
      this._profile = Profile.fromJson(response);
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
        "imageUrl":
            "https://products.image.dev.s3.ap-south-1.amazonaws.com/5f7730a57a8a7aafb139f511_hLOmFS.png"
      });
      return HttpService()
          .patch('${Constants.UPDATE_BUSINESS_INFROMATION}', body);
    } catch (error) {
      throw (error);
    }
  }
}
