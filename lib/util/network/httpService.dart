import 'dart:convert';
import 'package:http/http.dart' as http;
import '../flavor.dart';
import 'httpExceptions.dart';
import '../SecureStorage.dart';

class HttpService {
  final _baseUrl = Flavor.shared.baseUrl;

  Future<dynamic> get(String url) async {
    final token = await SecureStorage().getAuthToken();
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };
    print("-->${_baseUrl + url}");
    final response = await http.get(_baseUrl + url, headers: headers);
    return returnResponse(response);
  }

  Future<dynamic> put(String url, final body) async {
    final token = await SecureStorage().getAuthToken();
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };
    final response =
        await http.put('$_baseUrl$url', body: body, headers: headers);
    return returnResponse(response);
  }

  Future<dynamic> patch(String url, final body) async {
    final token = await SecureStorage().getAuthToken();
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };
    final response =
        await http.patch('$_baseUrl$url', body: body, headers: headers);
    return returnResponse(response);
  }

  Future<dynamic> post(String url, final body) async {
    final token = await SecureStorage().getAuthToken();
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };
    final response =
        await http.post('$_baseUrl$url', body: body, headers: headers);
    return returnResponse(response);
  }

  Future<dynamic> delete(String url) async {
    final token = await SecureStorage().getAuthToken();
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': token,
    };
    final response = await http.delete('$_baseUrl$url', headers: headers);
    return returnResponse(response);
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 204:
        return;
      case 200:
      case 201:
        print(json.decode(response.body));
        return json.decode(response.body);

      case 400:
        throw BadRequestException();

      case 401:
      case 403:
        throw UanuthorizedException();

      case 500:
      case 503:
      case 504:
        throw ServerErrorException();

      default:
        throw HttpServiceException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
