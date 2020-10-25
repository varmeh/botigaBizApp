import 'package:flutter/foundation.dart';
import '../../util/network/index.dart' show HttpService;
import '../../models/Profile/Profile.dart';

class ProfileProvider with ChangeNotifier {
  Profile _profile;

  // get allAprtment {
  //   if (this._apartments != null && this._apartments.apartments.length > 0) {
  //     return this._apartments.apartments;
  //   }
  //   return [];
  // }

  // get defaultAppartment {
  //   if (this._apartments != null && this._apartments.apartments.length > 0) {
  //     return this._apartments.apartments.first;
  //   }
  //   return null;
  // }

  get profileInfo {
    return this._profile;
  }

  Future fetchProfile() async {
    try {
      final response = await HttpService().get('/api/seller/profile');
      this._profile = Profile.fromJson(response);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
