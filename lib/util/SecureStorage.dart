import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final SecureStorage _singleton = new SecureStorage._internal();
  SecureStorage._internal();
  final FlutterSecureStorage storage = new FlutterSecureStorage();
  final String _authToken = 'authToken';
  final String _showIntroScreenCompelted = 'showIntro';
  String _authenticationToken;

  factory SecureStorage() {
    return _singleton;
  }

  get authenticationToken {
    return this._authenticationToken;
  }

  Future setAuthToken(String value) async {
    try {
      this._authenticationToken = value;
      return await storage.write(key: _authToken, value: value);
    } catch (error) {
      throw (error);
    }
  }

  Future getAuthToken() async {
    try {
      final String token = await storage.read(key: _authToken);
      this._authenticationToken = token;
      return token;
    } catch (error) {
      throw (error);
    }
  }

  Future setIntroStatusCompleted() async {
    try {
      return await storage.write(key: _showIntroScreenCompelted, value: 'done');
    } catch (error) {
      throw (error);
    }
  }

  Future getIntroStatusCompleted() async {
    try {
      return await storage.read(key: _showIntroScreenCompelted);
    } catch (error) {
      throw (error);
    }
  }

  Future expireToken() async {
    //FOR TEST PURPOSE
    // await storage.write(key: _authToken, value: "123");
    //storage.deleteAll();
  }
}
