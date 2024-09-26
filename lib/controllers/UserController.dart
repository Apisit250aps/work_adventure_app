import 'package:get/get.dart';
import 'package:work_adventure/models/user_model.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:work_adventure/utils/jwt_storage.dart';

class UserController extends GetxController {
  final RestServiceController _rest = Get.put(RestServiceController());
  final ApiService _apiService = Get.put(ApiService());

  var token = ''.obs; // สร้างตัวแปร token เป็น observable
  var user = {}.obs; // สร้างตัวแปร user เป็น observable
  var isAuthenticated =
      false.obs; // สร้างตัวแปร isAuthenticated เป็น observable

  @override
  void onInit() {
    super.onInit();
    _loadToken();
  }

  void _loadToken() async {
    final String? _token = await JwtStorage.getToken();
    if (_token != null && _token.isNotEmpty) {
      token.value = _token; // อัปเดต token
      final User? _user = await fetchUser(); // เรียก fetchUser
      user.value = _user?.toJson() ?? {}; // แปลงอ็อบเจ็กต์ User เป็น JSON ถ้ามี
      isAuthenticated.value = true; // เปลี่ยนสถานะเป็น authenticated
      
    } else {
      user.value = {};
      isAuthenticated.value = false; // เปลี่ยนสถานะเป็น unauthenticated
    }
  }

  Future<dynamic> register(
    String email,
    String username,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(_rest.register),
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
      final response = await http.post(
        Uri.parse(_rest.login),
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

  Future<User?> fetchUser() async {
    try {
      final response = await _apiService.get(_rest.auth);
      if (response.statusCode == 200) {
        final userData = json.decode(response.body); // แปลง JSON เป็น Map
        return User.fromJson(
            userData); // ใช้ factory method หรือ constructor ในคลาส User เพื่อสร้างอ็อบเจ็กต์
      }
      return null; // คืนค่า null ถ้า response ไม่สำเร็จ
    } catch (e) {
      print('Error fetching user: $e');
      return null; // คืนค่า null ในกรณีเกิดข้อผิดพลาด
    }
  }
}
