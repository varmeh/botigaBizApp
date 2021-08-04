import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../util/index.dart' show Http;

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

  Future uploadImageToS3(String url, File image) async {
    Uint8List bytes = await image.readAsBytes();
    return http.put(Uri.parse(url), body: bytes);
  }

  Future deleteImageFromS3(String url) async {
    return await Http.post('/api/services/image/delete',
        body: {'imageUrl': url});
  }

  Future getAreaFromPincode(String pin) async {
    final response = await http
        .get(Uri.parse('http://www.postalpincode.in/api/pincode/$pin'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load code');
    }
  }

  Future getPresignedePdfUrl() async {
    return await Http.get('/api/services/url/pdf');
  }

  Future uploadPdfToS3(String url, File image) async {
    Uint8List bytes = await image.readAsBytes();
    return http.put(Uri.parse(url), body: bytes);
  }
}
