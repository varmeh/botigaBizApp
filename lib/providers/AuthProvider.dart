import 'package:flutter/foundation.dart';
import '../util/index.dart' show Http, Token;

class AuthProvider with ChangeNotifier {
  Future signInWithPin(String phone, String pin) async {
    return Http.postAuth('/api/seller/auth/signin/pin',
        body: {"phone": phone, "pin": pin});
  }

  Future getOTP(String phone) async {
    return Http.get('/api/seller/auth/otp/$phone');
  }

  Future verifyOtp(String phone, String sessionId, String otpVal) async {
    return await Http.postAuth('/api/seller/auth/otp/verify',
        body: {"phone": phone, "sessionId": sessionId, "otpVal": otpVal});
  }

  Future updatePin(String phone, String pin) async {
    return Http.patch('/api/seller/auth/pin', body: {"pin": pin});
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
    return await Http.postAuth('/api/seller/auth/signup', body: {
      "businessName": businessName,
      "businessCategory": businessCategory,
      "firstName": firstName,
      "lastName": lastName,
      "brandName": brandName,
      "phone": phone,
      ...(tagline != null && tagline != '') ? {"tagline": tagline} : {},
      ...(url != null && url != '') ? {"brandUrl": url} : {}
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
    return Token.delete();
  }
}
