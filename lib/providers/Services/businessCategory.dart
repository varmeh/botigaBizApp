import '../../util/index.dart' show Http;

class Businesscategory {
  static Future getbusinessCategory() async {
    return await Http.get('/api/services/businessCategory');
  }
}
