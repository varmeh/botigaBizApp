import 'package:flutter/foundation.dart';
import '../../../util/constants.dart';
import '../../../util/network/index.dart' show HttpService;
import '../../../models/Store/Product/ProductByCategory.dart';

class ProductProvider with ChangeNotifier {
  List<ProductByCategory> _products;

  get allProducts {
    return this._products;
  }

  int productCountForCategory(String categoryId) {
    final ProductByCategory catgoryProdut = _products.firstWhere(
        (product) => product.categoryId == categoryId,
        orElse: () => null);
    if (catgoryProdut != null) {
      return catgoryProdut.products.length;
    }
    return 0;
  }

  Future<void> fetchProducts() async {
    try {
      final response = await HttpService().get('${Constants.GET_ALL_PRODUCTS}');
      List<ProductByCategory> items = [];
      for (var product in response) {
        items.add(ProductByCategory.fromJson(product));
      }
      _products = items;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
