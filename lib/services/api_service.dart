import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:work_adventure/utils/jwt_storage.dart';

class ApiService {
  static const String baseUrl = 'http://your-api-url.com/api';

  Future<http.Response> get(String endpoint) async {
    final token = await JwtStorage.getToken();
    return await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  Future<http.Response> post(String endpoint, dynamic data) async {
    final token = await JwtStorage.getToken();
    return await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(data),
    );
  }

  // เพิ่มเมธอดสำหรับ PUT, DELETE ตามต้องการ
}
