import 'package:shared_preferences/shared_preferences.dart';

const _tokenResetCounter = 200;

class KeyStore {
  static const _keyFirstRun = 'firstRun';
  static const _keyPushTokenRegistered = 'pushTokenRegisterd';
  static SharedPreferences _prefs;

  KeyStore._privateConstructor();
  static final shared = KeyStore._privateConstructor();

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool firstRun() {
    return !_prefs.containsKey(_keyFirstRun);
  }

  static Future<void> setFirstRun() async {
    await _prefs.setBool(_keyFirstRun, true);
  }

  Future<bool> resetToken() async {
    bool _resetToken = true;
    if (_prefs.containsKey(_keyPushTokenRegistered)) {
      int value = _prefs.getInt(_keyPushTokenRegistered);
      if (value > 0) {
        value--;
        _resetToken = false;
      } else {
        value = _tokenResetCounter;
      }
      await _prefs.setInt(_keyPushTokenRegistered, value);
    } else {
      // Initialize token counter
      await _prefs.setInt(_keyPushTokenRegistered, _tokenResetCounter);
    }
    return _resetToken;
  }
}
