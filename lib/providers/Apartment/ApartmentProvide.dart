import 'package:flutter/foundation.dart';
import '../../util/constants.dart';
import '../../util/network/index.dart' show HttpService;
import '../../models/Apartment/Apartments.dart';

class ApartmentProvider with ChangeNotifier {
  Apartments _apartments;

  get allAprtment {
    return this._apartments.apartments;
  }

  Future<void> fetchApartments() async {
    try {
      final response = await HttpService().get('${Constants.GET_APARTMENT}');
      _apartments = Apartments.fromJson(response);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
