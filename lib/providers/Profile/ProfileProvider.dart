import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../../util/network/index.dart' show HttpService;
import '../../util/constants.dart';
import '../../models/Profile/Profile.dart';

class ProfileProvider with ChangeNotifier {
  Profile _profile;

  get allApartment {
    return this._profile.apartments;
  }

  get defaultApartment {
    this._profile.apartments.first;
  }

  get profileInfo {
    return this._profile;
  }

  Future setApartmentStatus(String apartmentid, bool status) async {
    try {
      final body = json.encode({"apartmentId": apartmentid, "live": status});
      return HttpService().patch('${Constants.CHANGE_APT_STATUS}', body);
    } catch (error) {
      throw (error);
    }
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

  Future updateStoreDetails(
      String phone,
      String whatsapp,
      String email,
      String building,
      String street,
      String area,
      String city,
      String state,
      String pincode) async {
    try {
      final body = json.encode({
        "phone": phone,
        "email": email,
        "whatsapp": whatsapp,
        "address": {
          "building": building,
          "street": street,
          "area": area,
          "pincode": int.parse(pincode),
          "city": city,
          "state": state
        }
      });
      return HttpService().patch('${Constants.UPDATE_STORE_DETAILS}', body);
    } catch (error) {
      throw (error);
    }
  }

  Future addApartment(String apartmentId, String phone, String whatsapp,
      String email, String deliveryType, int day) async {
    try {
      final body = json.encode({
        "apartmentId": apartmentId,
        "phone": phone,
        "whatsapp": whatsapp,
        "email": email,
        "deliveryType": deliveryType,
        "day": day
      });
      print(body);
      return HttpService().post('/api/seller/apartments', body);
    } catch (error) {
      throw (error);
    }
  }
}
