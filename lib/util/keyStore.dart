import 'package:shared_preferences/shared_preferences.dart';

class KeyStore {
  static const _keyFirstRun = 'firstRun';
  static const _imageInfoModal = 'imageInfoModal';
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

  static Future<void> setDontShowImageInfoModal() async {
    await _prefs.setBool(_imageInfoModal, true);
  }

  static bool showImageInfoModal() {
    return !_prefs.containsKey(_imageInfoModal);
  }

  bool get isPushTokenRegistered =>
      !_prefs.containsKey(_keyPushTokenRegistered);

  Future<void> registerPushToken() async {
    await _prefs.setBool(_keyPushTokenRegistered, true);
  }
}
