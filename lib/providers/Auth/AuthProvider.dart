import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../util/network/index.dart' show HttpService;
import '../../util/index.dart';

class AuthProvider with ChangeNotifier {
  final secureStorage = SecureStorage();
  final baseUrl = Flavor.shared.baseUrl;

  Future validateToken() async {
    try {
      return HttpService().get('${Constants.VALIDATE_TOKEN}');
    } catch (err) {
      throw (err);
    }
  }

  Future signInWithPin(String phone, String pin) async {
    try {
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final body = json.encode({"phone": phone, "pin": pin});
      final response = await http.post('$baseUrl${Constants.SIGNIN_WITH_PIN}',
          headers: headers, body: body);
      if (response.statusCode == 200) {
        final authToken = response.headers['authorization'];
        await secureStorage.setAuthToken(authToken);
      }
      return HttpService().returnResponse(response);
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
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final body = json
          .encode({"phone": phone, "sessionId": sessionId, "otpVal": otpVal});
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
        ...(tagline != null && tagline != '') ? {"tagline": tagline} : {},
        ...(url != null && url != '') ? {"brandUrl": url} : {}
      });
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
      final response = await http.post('$baseUrl${Constants.SIGNUP}',
          headers: headers, body: body);
      if (response.statusCode == 201) {
        final authToken = response.headers['authorization'];
        await secureStorage.setAuthToken(authToken);
      }
      return HttpService().returnResponse(response);
    } catch (error) {
      throw (error);
    }
  }

  Future logout() async {
    try {
      final body = json.encode({});
      final response =
          await HttpService().post('/api/seller/auth/signout', body);
      await secureStorage.expireToken();
      return response;
    } catch (err) {
      throw (err);
    }
  }
}
