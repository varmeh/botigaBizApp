import 'package:flutter/foundation.dart';
import '../../util/index.dart' show Http;
import '../../models/Store/Product/ProductByCategory.dart';

class ProductProvider with ChangeNotifier {
  List<ProductByCategory> _products = [];
  bool _hasProducts = false;

  get allProducts {
    return this._products;
  }

  get hasProducts {
    return this._hasProducts;
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

  Product getProductById(String categoryId, String productId) {
    Product product;
    final ProductByCategory categoryProduct = _products.firstWhere(
        (product) => product.categoryId == categoryId,
        orElse: () => null);
    if (categoryProduct != null) {
      product = categoryProduct.products
          .firstWhere((product) => product.id == productId, orElse: () => null);
    }
    return product;
  }

  Future<void> fetchProducts() async {
    final response = await Http.get('/api/seller/products');
    List<ProductByCategory> items = [];
    for (var product in response) {
      items.add(ProductByCategory.fromJson(product));
    }
    _products = items;
    this._hasProducts = true;
    notifyListeners();
  }

  Future saveProduct(String categoryId, String name, double price, int quantity,
      String unit, String imageUrl, String description) async {
    return Http.post('/api/seller/products', body: {
      "categoryId": categoryId,
      "name": name,
      "price": price,
      "size": {"quantity": '$quantity', "unit": unit},
      "imageUrl": imageUrl,
      "description": description,
      "available": true
    });
  }

  Future updateProductStatus(
      String categoryId, Product product, bool availableStatus) async {
    List productSpec = product.size.split(" ");
    return Http.patch('/api/seller/products', body: {
      "categoryId": categoryId,
      "productId": product.id,
      "name": product.name,
      "price": product.price,
      "unit": productSpec.elementAt(1),
      "quantity": productSpec.elementAt(0),
      "available": availableStatus,
      "updateImage": false,
      "imageUrl": product.imageUrl,
      "description": product.description,
    });
  }

  Future updateProduct(
      String categoryId,
      String productId,
      String name,
      double price,
      int quantity,
      String unit,
      String imageUrl,
      String description,
      bool availableStatus,
      bool updateImagurl) async {
    return Http.patch('/api/seller/products', body: {
      "categoryId": categoryId,
      "productId": productId,
      "name": name,
      "price": price,
      "unit": unit,
      "quantity": quantity,
      "available": availableStatus,
      "updateImage": updateImagurl,
      "imageUrl": imageUrl,
      "description": description,
    });
  }

  Future deleteProduct(
    String categoryId,
    String productId,
  ) async {
    return Http.delete(
        '/api/seller/products/$productId/categories/$categoryId');
  }
}
