import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/profile/index.dart';
import '../util/index.dart' show Http, Token;

class ProfileProvider with ChangeNotifier {
  Profile _profile;
  bool _hasProfile = false;

  get hasProfile {
    return this._hasProfile;
  }

  get allApartment {
    if (this._profile != null) {
      return this._profile.apartments;
    }
  }

  get totalApartment {
    if (this._profile != null && this._profile.apartments != null) {
      return this._profile.apartments.length;
    }
    return 0;
  }

  get defaultApartment {
    if (this._profile != null && this._profile.apartments.length > 0) {
      return this._profile.apartments.first;
    }
  }

  get hasAnyEnabledApartment {
    if (this._profile != null && this._profile.apartments.length > 0) {
      final apartment = this
          ._profile
          .apartments
          .firstWhere((apt) => apt.live == true, orElse: () => null);
      if (apartment != null) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  get profileInfo {
    return this._profile;
  }

  Future setApartmentStatus(String apartmentid, bool status) async {
    return Http.patch('/api/seller/apartments/live',
        body: {'apartmentId': apartmentid, 'live': status});
  }

  Future fetchProfile() async {
    final response = await Http.get('/api/seller/profile');
    this._profile = Profile.fromJson(response);
    this._hasProfile = true;
    notifyListeners();
  }

  Future updateBusinessInfromation(String brandName, String tagline,
      String imageUrl, String businessCategory, bool updateImage) async {
    return Http.patch('/api/seller/profile/business', body: {
      'brandName': brandName,
      'tagline': tagline,
      'imageUrl': imageUrl,
      'updateImage': updateImage
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
      ...(phone != '' && phone != null) ? {'phone': phone} : {},
      'email': email,
      'whatsapp': whatsapp,
      'address': {
        'building': building,
        'street': street,
        'area': area,
        'pincode': pincode,
        'city': city,
        'state': state
      }
    });
  }

  Future addApartment(String apartmentId, String phone, String whatsapp,
      String email, String deliveryType, int day) async {
    return Http.post('/api/seller/apartments', body: {
      'apartmentId': apartmentId,
      'phone': phone,
      'whatsapp': whatsapp,
      'email': email,
      'deliveryType': deliveryType,
      'day': day
    });
  }

  Future updateApartmentDeliveryScheduled(
      String apartmentId, String deliveryType, int day) async {
    return Http.patch('/api/seller/apartments/delivery', body: {
      'apartmentId': apartmentId,
      'deliveryType': deliveryType,
      'day': day
    });
  }

  Future updateApartmentContactInformation(
      String apartmentId, String email, String whatsapp, String phone) async {
    return Http.patch('/api/seller/apartments/contact', body: {
      'apartmentId': apartmentId,
      'phone': phone,
      'whatsapp': whatsapp,
      'email': email
    });
  }

  Future restProfile() async {
    this._profile = null;
    this._hasProfile = false;
    notifyListeners();
  }

  Future signInWithPin(String phone, String pin) async {
    return Http.postAuth('/api/seller/auth/signin/pin',
        body: {'phone': phone, 'pin': pin});
  }

  Future getOTP(String phone) async {
    return Http.get('/api/seller/auth/otp/$phone');
  }

  Future verifyOtp(String phone, String sessionId, String otpVal) async {
    return await Http.postAuth('/api/seller/auth/otp/verify',
        body: {'phone': phone, 'sessionId': sessionId, 'otpVal': otpVal});
  }

  Future updatePin(String phone, String pin) async {
    return Http.patch('/api/seller/auth/pin', body: {'pin': pin});
  }

  Future signup(
      String businessName,
      String businessCategory,
      String firstName,
      String lastName,
      String brandName,
      String phone,
      String tagline,
      String url,
      String createToken) async {
    return await Http.postAuth('/api/seller/auth/signup', body: {
      'businessName': businessName,
      'businessCategory': businessCategory,
      'firstName': firstName,
      'lastName': lastName,
      'brandName': brandName,
      'phone': phone,
      ...(tagline != null && tagline != '') ? {'tagline': tagline} : {},
      ...(url != null && url != '') ? {'brandUrl': url} : {},
      'createToken': createToken
    });
  }

  Future logout() async {
    /*
    We set token to '' and not as Null 
    to indicate user logged out and on second launch he can be 
    redirected to login screen 
    rather then intro screen.
    */
    await Http.post('/api/seller/auth/signout', body: {});
    return Token.write('');
  }

  Future getBankNameFromIfsc(String ifsc) async {
    final response =
        await http.get('https://ifsc.razorpay.com/${ifsc.toUpperCase()}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load code');
    }
  }

  Future getBankDetails() async {
    return await Http.get('/api/seller/profile/bankdetails');
  }

  Future updateBankDetails(String beneficiaryName, String accountNumber,
      String ifscCode, String bankName, String accountType) async {
    return Http.patch(
      '/api/seller/profile/bankdetails',
      body: {
        "beneficiaryName": beneficiaryName,
        "accountNumber": accountNumber,
        "ifscCode": ifscCode,
        "bankName": bankName,
        "accountType": accountType
      },
    );
  }
}
