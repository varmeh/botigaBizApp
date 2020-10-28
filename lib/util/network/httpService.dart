import 'dart:io';
import 'dart:convert';
import '../flavor.dart';
import '../SecureStorage.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final _baseUrl = Flavor.shared.baseUrl;
  final Map<String, String> commonHeader = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  Future<dynamic> get(String url) async {
    String token = SecureStorage().authenticationToken;
    Map<String, String> headers = {...commonHeader, 'Authorization': token};
    final response = await http.get(_baseUrl + url, headers: headers);
    return returnResponse(response);
  }

  Future<dynamic> put(String url, final body) async {
    String token = SecureStorage().authenticationToken;
    Map<String, String> headers = {...commonHeader, 'Authorization': token};
    final response =
        await http.put('$_baseUrl$url', body: body, headers: headers);
    return returnResponse(response);
  }

  Future<dynamic> patch(String url, final body) async {
    String token = SecureStorage().authenticationToken;
    Map<String, String> headers = {...commonHeader, 'Authorization': token};
    final response =
        await http.patch('$_baseUrl$url', body: body, headers: headers);
    return returnResponse(response);
  }

  Future<dynamic> post(String url, final body) async {
    String token = SecureStorage().authenticationToken;
    Map<String, String> headers = {...commonHeader, 'Authorization': token};
    final response =
        await http.post('$_baseUrl$url', body: body, headers: headers);
    return returnResponse(response);
  }

  Future<dynamic> delete(String url) async {
    final token = SecureStorage().authenticationToken;
    Map<String, String> headers = {...commonHeader, 'Authorization': token};
    final response = await http.delete('$_baseUrl$url', headers: headers);
    return returnResponse(response);
  }

  dynamic returnResponse(http.Response response) {
    if (response.statusCode == 204) {
      return;
    }
    final data = json.decode(response.body);
    if (response.statusCode >= 500) {
      final msg =
          data['message'] != null ? data['message'] : 'Something went wrong';
      throw HttpException(msg);
    } else if (response.statusCode >= 400) {
      final msg =
          data['message'] != null ? data['message'] : 'Somethig went wrong';
      throw FormatException(msg);
    } else {
      return data;
    }
  }

  static String message(dynamic exception) {
    var msg;
    if (exception is SocketException) {
      msg = 'No Internet Connection';
    } else if (exception is HttpException) {
      msg = exception.message;
    } else if (exception is FormatException) {
      msg = exception.message;
    }
    return msg;
  }
}
