import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';
import 'dart:convert';

import 'package:work_adventure/utils/jwt_storage.dart';

class AuthService {
  final RestServiceController _authRest = Get.put(RestServiceController());
  final ApiService _apiService = Get.put(ApiService());

  Future<dynamic> register(
    String email,
    String username,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(_authRest.register),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'username': username,
          'password': password,
        }),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      print(_authRest.login);
      final response = await http.post(
        Uri.parse(_authRest.login),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        if (token != null) {
          await JwtStorage.saveToken(token);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> isAuthenticated() async {
    try {
      final response = await _apiService.get(_authRest.auth);
      if (response.statusCode == 200) {
        return response.body;
      }
    } catch (e) {
      return {};
    }
  }

  Future<void> logout() async {
    await JwtStorage.deleteToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await JwtStorage.getToken();
    return token != null;
  }
}
