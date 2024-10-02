import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:work_adventure/utils/jwt_storage.dart';

class ApiService extends GetxController {
  Future<http.Response> get(String endpoint) async {
    final token = await JwtStorage.getToken();
    return await http.get(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> post(String endpoint, dynamic data) async {
    final token = await JwtStorage.getToken();
    return await http.post(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final token = await JwtStorage.getToken();
    return await http.delete(
      Uri.parse(endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
}
