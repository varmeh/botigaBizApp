import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../models/Auth/Auth.dart';
import '../../util/network/index.dart' show HttpService;
import '../../util/index.dart';

class AuthProvider with ChangeNotifier {
  final secureStorage = SecureStorage();
  final baseUrl = Flavor.shared.baseUrl;
  Auth authProfile;

  Future validateToken() async {
    try {
      final authToken = await secureStorage.getAuthToken();
      final response = await http.get('$baseUrl${Constants.SIGNIN_WITH_PIN}',
          headers: <String, String>{
            'Authorization': authToken,
          });
      if (response.statusCode == 200) {
        return "Valid Token";
      } else {
        throw Exception('Invalid Token');
      }
    } catch (err) {
      throw (err);
    }
  }

  Future signInWithPin(String phone, String pin) async {
    try {
      final body = json.encode({"phone": phone, "pin": pin});
      final response =
          await http.post('$baseUrl${Constants.SIGNIN_WITH_PIN}', body: body);
      if (response.statusCode == 200) {
        final authToken = response.headers['authorization'];
        await secureStorage.setAuthToken(authToken);
        this.authProfile = Auth.fromJson(jsonDecode(response.body));
        return notifyListeners();
      } else {
        throw Exception('Unable to login');
      }
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

  Future signup(
      String businessName,
      String businessCategory,
      String firstName,
      String lastName,
      String brandName,
      String phone,
      String tagline,
      String url) {
    try {
      final body = json.encode({
        "businessName": businessName,
        "businessCategory": businessCategory,
        "firstName": firstName,
        "lastName": lastName,
        "brandName": brandName,
        "phone": phone,
        "tagline": tagline,
        "brandUrl": url
      });
      return HttpService().patch('${Constants.SIGNUP}', body);
    } catch (error) {
      throw (error);
    }
  }
}
