import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../util/index.dart' show Http;

class ImageService {
  static Future getPresignedImageUrl() async {
    try {
      return await Http.get('/api/services/imageurls/png');
    } catch (error) {
      throw (error);
    }
  }

  static Future getPresignedBrandImageUrl() async {
    try {
      return await Http.get('/api/services/brandimageurls/png');
    } catch (error) {
      throw (error);
    }
  }

  static Future uploadImageToS3(String url, PickedFile image) async {
    try {
      Uint8List bytes = await image.readAsBytes();
      return http.put(url, body: bytes);
    } catch (error) {
      throw (error);
    }
  }
}
