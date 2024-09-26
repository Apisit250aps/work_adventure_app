import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:work_adventure/utils/jwt_storage.dart';

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:3000/api';

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final token = json.decode(response.body)['token'];
      await JwtStorage.saveToken(token);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await JwtStorage.deleteToken();
  }

  Future<bool> isLoggedIn() async {
    final token = await JwtStorage.getToken();
    return token != null;
  }
}