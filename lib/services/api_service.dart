import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:work_adventure/utils/jwt_storage.dart';

class ApiService extends GetxController {
  Future<http.Response> _handleResponse(
      Future<http.Response> Function() apiCall) async {
    try {
      final response = await apiCall();
      if (response.statusCode == 403) {
        await logout();
        throw Exception('Token expired. User logged out.');
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> get(String endpoint) async {
    return _handleResponse(() async {
      final token = await JwtStorage.getToken();
      return await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    });
  }

  Future<http.Response> post(String endpoint, dynamic data) async {
    return _handleResponse(() async {
      final token = await JwtStorage.getToken();
      return await http.post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );
    });
  }

  Future<http.Response> delete(String endpoint) async {
    return _handleResponse(() async {
      final token = await JwtStorage.getToken();
      return await http.delete(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    });
  }

  Future<http.Response> put(String endpoint, dynamic data) async {
    return _handleResponse(() async {
      final token = await JwtStorage.getToken();
      return await http.put(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );
    });
  }

  Future<bool> logout() async {
    try {
      await JwtStorage.deleteToken();
      Get.offAllNamed('/login');
      return true;
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }
}
