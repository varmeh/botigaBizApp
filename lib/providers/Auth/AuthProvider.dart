import 'package:flutter/foundation.dart';
import '../../util/constants.dart';
import '../../util/network/index.dart' show HttpService;
import '../../models/Auth/Auth.dart';
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  Auth authProfile;

  set authLoginProfile(value) {
    this.authProfile = Auth.fromJson(value);
  }

  Future signInWithPin(String phone, String pin) async {
    try {
      final body = json.encode({"phone": phone, "pin": pin});
      return HttpService().post('${Constants.SIGNIN_WITH_PIN}', body);
    } catch (error) {
      throw (error);
    }
  }

  Future getOTP(String phone) {
    try {
      return HttpService().get('${Constants.SIGNIN_WITH_PIN}/phone');
    } catch (error) {
      throw (error);
    }
  }

  Future verifyOtp(String phone, String sessionId, String otpVal) {
    try {
      final body = json
          .encode({"phone": phone, "sessionId": sessionId, "otpVal": otpVal});
      return HttpService().post('${Constants.VERIFY_OTP}', body);
    } catch (error) {
      throw (error);
    }
  }

  Future updatePin(String phone, String pin) {
    try {
      final body = json.encode({"pin": pin});
      return HttpService().patch('${Constants.UPDATE_PIN}', body);
    } catch (error) {
      throw (error);
    }
  }
}
