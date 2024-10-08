import 'package:flutter/foundation.dart';

import '../../models/store/index.dart';
import '../../util/index.dart' show Http;

class CategoryProvider with ChangeNotifier {
  List<StoreCategory> _categories = [];
  bool _hasCategories = false;

  get allCategories {
    return this._categories;
  }

  get hasCategories {
    return this._hasCategories;
  }

  Future<void> fetchCategories() async {
    final response = await Http.get('/api/seller/categories');
    List<StoreCategory> items = [];
    for (var category in response) {
      items.add(StoreCategory.fromJson(category));
    }
    _categories = items;
    _hasCategories = true;
    notifyListeners();
  }

  Future deleteCategory(String categoryId) async {
    return Http.delete('/api/seller/categories/$categoryId');
  }

  Future saveCategory(String name) async {
    return Http.post('/api/seller/categories', body: {
      'name': name,
    });
  }

  Future editCategory(String categoryId, String name) async {
    return Http.patch('/api/seller/categories', body: {
      'categoryId': categoryId,
      'name': name,
    });
  }

  Future updateCategoryVisiblity(String categoryId, bool visible) {
    return Http.patch('/api/seller/categories/visible', body: {
      'categoryId': categoryId,
      'visible': visible,
    });
  }

  Future resetCategory() async {
    this._categories = [];
    this._hasCategories = false;
    notifyListeners();
  }
}
