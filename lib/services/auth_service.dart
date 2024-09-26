import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:work_adventure/utils/jwt_storage.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:3000'; // สำหรับ Android Emulator

  Future<bool> login(String username, String password) async {
    print('Attempting login for username: $username');
    print('Base URL: $baseUrl');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData['token'];
        if (token != null) {
          await JwtStorage.saveToken(token);
          print('Login successful. Token saved.');
          return true;
        } else {
          print('Login failed. Token not found in response.');
          return false;
        }
      } else {
        print('Login failed. Unexpected status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error during login: $e');
      return false;
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
