import 'package:flutter/foundation.dart';
import '../../../util/constants.dart';
import 'dart:convert';
import '../../../util/network/index.dart' show HttpService;
import '../../../models/Store/Product/ProductByCategory.dart';

class ProductProvider with ChangeNotifier {
  List<ProductByCategory> _products = [];

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

  Future saveProduct(String categoryId, String name, double price, int quantity,
      String unit, String imageUrl, String description) async {
    try {
      final body = json.encode({
        "categoryId": categoryId,
        "name": name,
        "price": price,
        "size": {"quantity": '$quantity', "unit": unit},
        "imageUrl": imageUrl,
        "description": description,
        "available": true
      });
      return HttpService().post('${Constants.ADD_PRODUCT}', body);
    } catch (error) {
      throw (error);
    }
  }

  Future updateProductStatus(
      String categoryId, String productId, bool availabelStatus) {
    try {
      final body = json.encode({
        "categoryId": categoryId,
        "productId": productId,
        "available": availabelStatus
      });
      return HttpService().patch('${Constants.ADD_PRODUCT}', body);
    } catch (error) {
      throw (error);
    }
  }
}
