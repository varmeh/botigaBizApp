import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../util/index.dart' show Http;

class ImageService {
  static Future getPresignedImageUrl() async {
    return await Http.get('/api/services/imageurls/png');
  }

  static Future getPresignedBrandImageUrl() async {
    return await Http.get('/api/services/brandimageurls/png');
  }

  static Future uploadImageToS3(String url, PickedFile image) async {
    Uint8List bytes = await image.readAsBytes();
    return http.put(url, body: bytes);
  }
}
