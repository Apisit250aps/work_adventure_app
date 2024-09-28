import 'package:get/get.dart';
import 'package:work_adventure/models/character_statistic_model.dart';
import 'package:work_adventure/models/user_model.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:work_adventure/utils/jwt_storage.dart';

class UserController extends GetxController {
  final RestServiceController _rest = Get.find();
  final ApiService _apiService = Get.find();

  var token = ''.obs;
  var user = {}.obs;
  var characters = <Character>[].obs;
  var isAuthenticated = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoading.value = true;
    _loadToken();
  }

  @override
  void onReady() {
    super.onReady();
    isLoading.value = false;
    print('onReady called');
    // ใช้งานหลังจาก widget ถูกสร้างเสร็จแล้ว
  }

  @override
  void onClose() {
    print('onClose called');
    isLoading.value = false;
    // ทำงานล้างข้อมูลเมื่อปิด widget
    super.onClose();
  }

  void _loadToken() async {
    isLoading.value = true;
    final String? tokenStore = await JwtStorage.getToken();
    if (tokenStore != null && tokenStore.isNotEmpty) {
      token.value = tokenStore;
      final User? userData = await fetchUser();
      user.value = userData?.toJson() ?? {};
      isAuthenticated.value = true;
    } else {
      user.value = {};
      isAuthenticated.value = false;
    }
    isLoading.value = false;
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
      final response = await _apiService.get(_rest.userData);
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        return User.fromJson(userData[0]);
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }
}
