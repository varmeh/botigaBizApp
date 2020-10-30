import 'package:http/http.dart' as http;
import 'dart:convert';

class PinService {
  static Future getAreaFromPincode(String pin) async {
    final response =
        await http.get('http://www.postalpincode.in/api/pincode/$pin');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load code');
    }
  }
}
