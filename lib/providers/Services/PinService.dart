import 'package:http/http.dart' as http;
import '../../util/constants.dart';
import 'dart:convert';

class PinService {
  static Future getAreaFromPincode(String pin) async {
    try {
      final response = await http.get('${Constants.PINCODE_URL}/$pin');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load code');
      }
    } catch (error) {
      throw (error);
    }
  }
}
