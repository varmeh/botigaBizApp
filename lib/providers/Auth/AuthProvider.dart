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
      return HttpService().get('${Constants.VALIDATE_TOKEN}');
    } catch (err) {
      print('*********$err');
      throw (err);
    }
  }

  Future signInWithPin(String phone, String pin) async {
    try {
      final body = json.encode({"phone": phone, "pin": pin});
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.post('$baseUrl${Constants.SIGNIN_WITH_PIN}',
          headers: headers, body: body);
      if (response.statusCode == 200) {
        final authToken = response.headers['authorization'];
        await secureStorage.setAuthToken(authToken);
      }
      final authData = HttpService().returnResponse(response);
      this.authProfile = Auth.fromJson(authData);
      return notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future getOTP(String phone) async {
    try {
      return HttpService().get('${Constants.GET_OTP}/$phone');
    } catch (error) {
      throw (error);
    }
  }

  Future verifyOtp(String phone, String sessionId, String otpVal) async {
    try {
      final body = json
          .encode({"phone": phone, "sessionId": sessionId, "otpVal": otpVal});
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.post('$baseUrl${Constants.VERIFY_OTP}',
          headers: headers, body: body);
      final authToken = response.headers['authorization'];
      if (authToken != null) {
        await secureStorage.setAuthToken(authToken);
      }
      return HttpService().returnResponse(response);
    } catch (error) {
      throw (error);
    }
  }

  Future updatePin(String phone, String pin) async {
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
      String url) async {
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
      print("++$baseUrl${Constants.SIGNUP} $body");
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.post('$baseUrl${Constants.SIGNUP}',
          headers: headers, body: body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        final authToken = response.headers['authorization'];
        await secureStorage.setAuthToken(authToken);
      }
      return HttpService().returnResponse(response);
    } catch (error) {
      print('-->$error');
      throw (error);
    }
  }
}
