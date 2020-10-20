import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage storage = new FlutterSecureStorage();
  final String _authToken = 'authToken';
  final String _showIntroScreenCompelted = 'showIntro';

  Future setAuthToken(String value) async {
    try {
      return await storage.write(key: _authToken, value: value);
    } catch (error) {
      throw (error);
    }
  }

  Future getAuthToken() async {
    try {
      return await storage.read(key: _authToken);
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

  Future clearStorage() async {
    return await storage.deleteAll();
  }
}
