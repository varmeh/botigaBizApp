import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../util/constants.dart';
import '../../util/network/index.dart' show HttpService;

class ImageService {
  static Future getPresignedImageUrl() async {
    try {
      return await HttpService().get('${Constants.IMAGE_PRESIGNED_URL}');
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
