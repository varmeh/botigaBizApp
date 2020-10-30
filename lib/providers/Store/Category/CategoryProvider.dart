import 'package:flutter/foundation.dart';
import '../../../util/index.dart' show Http;
import '../../../models/Store/Category/StoreCategory.dart';

class CategoryProvider with ChangeNotifier {
  List<StoreCategory> _categories = [];

  get allCategories {
    return this._categories;
  }

  Future<void> fetchCategories() async {
    try {
      final response = await Http.get('/api/seller/categories');
      List<StoreCategory> items = [];
      for (var category in response) {
        items.add(StoreCategory.fromJson(category));
      }
      _categories = items;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future deleteCategory(String categoryId) async {
    try {
      return Http.delete('/api/seller/categories/$categoryId');
    } catch (error) {
      throw (error);
    }
  }

  Future saveCategory(String name) async {
    try {
      return Http.post('/api/seller/categories', body: {
        "name": name,
      });
    } catch (error) {
      throw (error);
    }
  }
}
