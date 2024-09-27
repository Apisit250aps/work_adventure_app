import 'package:get/get.dart';
import 'package:work_adventure/models/character_statistic_model.dart';
import 'package:work_adventure/models/user_model.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:work_adventure/utils/jwt_storage.dart';

class UserController extends GetxController {
  final RestServiceController _rest = Get.put(RestServiceController());
  final ApiService _apiService = Get.put(ApiService());

  var token = ''.obs;
  var user = {}.obs;
  var characters = <Character>[].obs;
  var isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadToken();
  }

  void _loadToken() async {
    final String? _token = await JwtStorage.getToken();
    if (_token != null && _token.isNotEmpty) {
      token.value = _token;
      final User? _userData = await fetchUser();
      user.value = _userData?.toJson() ?? {};
      isAuthenticated.value = true;
    } else {
      user.value = {};
      isAuthenticated.value = false;
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
