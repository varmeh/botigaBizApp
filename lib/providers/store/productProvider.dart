import 'package:flutter/foundation.dart';

import '../../models/store/index.dart';
import '../../util/index.dart' show Http;

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

  Future saveProduct(
      {String categoryId,
      String name,
      double price,
      final mrp, // double or null
      double quantity,
      String unit,
      String imageUrl,
      String description,
      String imageUrlLarge,
      List<String> secondaryImageUrls}) async {
    final body = {
      'categoryId': categoryId,
      'name': name,
      'price': price,
      'size': {'quantity': '$quantity', 'unit': unit},
      'imageUrl': imageUrl,
      'imageUrlLarge': imageUrlLarge,
      'secondaryImageUrls': [],
      'description': description,
      'available': true
    };

    if (mrp != null) {
      body['mrp'] = mrp;
    }

    return Http.post('/api/seller/products', body: body);
  }

  Future updateProductStatus(
      String categoryId, Product product, bool availableStatus) async {
    List productSpec = product.size.split(' ');
    return Http.patch('/api/seller/products', body: {
      'categoryId': categoryId,
      'productId': product.id,
      'name': product.name,
      'price': product.price,
      'unit': productSpec.elementAt(1),
      'quantity': productSpec.elementAt(0),
      'available': availableStatus,
      'imageUrl': product.imageUrl,
      'imageUrlLarge': product.imageUrlLarge,
      'secondaryImageUrls': product.secondaryImageUrls,
      'description': product.description,
    });
  }

  Future updateProduct(
      {String categoryId,
      String productId,
      String name,
      double price,
      double mrp,
      double quantity,
      String unit,
      String imageUrl,
      String description,
      bool availableStatus,
      String imageUrlLarge,
      List<String> secondaryImageUrls}) async {
    final body = {
      'categoryId': categoryId,
      'productId': productId,
      'name': name,
      'price': price,
      'unit': unit,
      'quantity': quantity,
      'available': availableStatus,
      'imageUrl': imageUrl,
      'description': description,
      'imageUrlLarge': imageUrlLarge,
      'secondaryImageUrls': secondaryImageUrls
    };

    if (mrp != null) {
      body['mrp'] = mrp;
    }
    return Http.patch('/api/seller/products', body: body);
  }

  Future deleteProduct(
    String categoryId,
    String productId,
  ) async {
    return Http.delete(
        '/api/seller/products/$productId/categories/$categoryId');
  }

  Future resetProduct() async {
    this._products = [];
    this._hasProducts = false;
    notifyListeners();
  }
}
