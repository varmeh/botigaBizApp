import 'package:flutter/foundation.dart';
import '../../../util/constants.dart';
import '../../../util/network/index.dart' show HttpService;
import '../../../models/Store/Category/StoreCategory.dart';

class CategoryProvider with ChangeNotifier {
  List<StoreCategory> _categories;

  get allCategories {
    return this._categories;
  }

  Future<void> fetchCategories() async {
    try {
      final response = await HttpService().get('${Constants.GET_ALL_CATEGORY}');
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
      return HttpService().delete('${Constants.DELETE_CATEGORY}/$categoryId');
    } catch (error) {
      throw (error);
    }
  }
}
