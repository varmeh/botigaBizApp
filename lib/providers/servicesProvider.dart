import '../util/index.dart' show Http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ServicesProvider with ChangeNotifier {
  Future getbusinessCategory() async {
    return await Http.get('/api/services/businessCategory');
  }

  Future getPresignedImageUrl() async {
    return await Http.get('/api/services/imageurls/png');
  }

  Future getPresignedBrandImageUrl() async {
    return await Http.get('/api/services/brandimageurls/png');
  }

  Future uploadImageToS3(String url, PickedFile image) async {
    Uint8List bytes = await image.readAsBytes();
    return http.put(url, body: bytes);
  }

  Future getAreaFromPincode(String pin) async {
    final response =
        await http.get('http://www.postalpincode.in/api/pincode/$pin');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load code');
    }
  }
}
