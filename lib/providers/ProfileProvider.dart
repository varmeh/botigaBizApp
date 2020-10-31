import 'package:flutter/foundation.dart';
import '../util/index.dart' show Http;
import '../models/Profile/Profile.dart';

class ProfileProvider with ChangeNotifier {
  Profile _profile;

  get allApartment {
    if (this._profile != null) {
      return this._profile.apartments;
    }
  }

  get defaultApartment {
    if (this._profile != null && this._profile.apartments.length > 0) {
      return this._profile.apartments.first;
    }
  }

  get profileInfo {
    return this._profile;
  }

  Future setApartmentStatus(String apartmentid, bool status) async {
    return Http.patch('/api/seller/apartments/live',
        body: {"apartmentId": apartmentid, "live": status});
  }

  Future fetchProfile() async {
    final response = await Http.get('/api/seller/profile');
    this._profile = Profile.fromJson(response);
    notifyListeners();
  }

  Future updateBusinessInfromation(String brandName, String tagline,
      String imageUrl, String businessCategory, bool updateImage) async {
    return Http.patch('/api/seller/profile/business', body: {
      "brandName": brandName,
      "tagline": tagline,
      "imageUrl": imageUrl,
      "updateImage": updateImage
    });
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
    return Http.patch('/api/seller/profile/contact', body: {
      ...(phone != '' && phone != null) ? {"phone": phone} : {},
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
  }

  Future addApartment(String apartmentId, String phone, String whatsapp,
      String email, String deliveryType, int day) async {
    return Http.post('/api/seller/apartments', body: {
      "apartmentId": apartmentId,
      "phone": phone,
      "whatsapp": whatsapp,
      "email": email,
      "deliveryType": deliveryType,
      "day": day
    });
  }

  Future updateApartmentDeliveryScheduled(
      String apartmentId, String deliveryType, int day) async {
    return Http.patch('/api/seller/apartments/delivery', body: {
      "apartmentId": apartmentId,
      "deliveryType": deliveryType,
      "day": day
    });
  }

  Future updateApartmentContactInformation(
      String apartmentId, String email, String whatsapp, String phone) async {
    return Http.patch('/api/seller/apartments/contact', body: {
      "apartmentId": apartmentId,
      "phone": phone,
      "whatsapp": whatsapp,
      "email": email
    });
  }
}
