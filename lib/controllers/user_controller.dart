import 'package:get/get.dart';
import 'package:work_adventure/models/character_model.dart';
import 'package:work_adventure/models/user_model.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:work_adventure/utils/jwt_storage.dart';
import 'package:work_adventure/screens/auth/login_screen.dart';

class UserController extends GetxController {
  final RestServiceController _rest = Get.find();
  final ApiService _apiService = Get.find();

  var token = ''.obs;
  final Rx<User?> user = Rx<User?>(null);
  var characters = <Character>[].obs;
  RxBool isAuthenticated = true.obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadToken();
  }

  @override
  void onReady() {
    super.onReady();
    print('onReady called');
    print("isAuthenticated $isAuthenticated");
    print("user $user");
  }

  @override
  void onClose() {
    print('onClose called');
    super.onClose();
  }

  void _loadToken() async {
    isLoading.value = true;
    final String? tokenStore = await JwtStorage.getToken();
    if (tokenStore != null && tokenStore.isNotEmpty) {
      token.value = tokenStore;
      final User? userData = await fetchUser();
      user.value = userData;
      print("user $user");
    } else {
      user.value = null;
      isAuthenticated.value = false;
    }
    isLoading.value = false;
  }

  Future<bool> register(
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
      return response.statusCode == 201;
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
          this.token.value = token;
          _loadToken();
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      // Clear local storage
      await JwtStorage.deleteToken();

      // Clear controller state
      token.value = '';
      user.value = null;
      characters.clear();
      isAuthenticated.value = false;

      // Navigate to login screen
      Get.offAll(() => const LoginScreen());

      return true;
    } catch (e) {
      print('Error during logout: $e');
      return false;
    }
  }

  Future<User?> fetchUser() async {
    try {
      final response = await _apiService.get(_rest.auth);
      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        return User.fromJson(userData);
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  Future<bool> checkAuthentication() async {
    try {
      return isAuthenticated.value;
    } catch (e) {
      return false;
    }
  }
}
