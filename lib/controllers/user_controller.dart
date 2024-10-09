import 'package:get/get.dart';
import 'package:work_adventure/models/character_model.dart';
import 'package:work_adventure/models/user_model.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:work_adventure/utils/jwt_storage.dart';

class UserController extends GetxController {
  final RestServiceController _rest = Get.find();
  final ApiService _apiService = Get.find();

  final RxString token = ''.obs;
  final Rx<User?> user = Rx<User?>(null);
  final RxList<Character> characters = <Character>[].obs;
  final RxBool isAuthenticated = false.obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    ever(isAuthenticated, _handleAuthChanged);
    _loadToken();
  }

  void _handleAuthChanged(bool isAuth) {
    if (isAuth) {
      Get.offAllNamed('/characters');
    } else {
      Get.offAllNamed('/login');
    }
  }

  Future<void> _loadToken() async {
    isLoading.value = true;
    try {
      final String? tokenStore = await JwtStorage.getToken();
      if (tokenStore != null && tokenStore.isNotEmpty) {
        token.value = tokenStore;
        final User? userData = await fetchUser();
        user.value = userData;
        isAuthenticated.value = userData != null;
      } else {
        _clearUserData();
      }
    } catch (e) {
      print('Error loading token: $e');
      _clearUserData();
    } finally {
      isLoading.value = false;
    }
  }

  void _clearUserData() {
    token.value = '';
    user.value = null;
    characters.clear();
    isAuthenticated.value = false;
  }

  Future<bool> register(String email, String username, String password) async {
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
      print('Error during registration: $e');
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
        final newToken = responseData['token'];
        if (newToken != null) {
          await JwtStorage.saveToken(newToken);
          token.value = newToken;
          await _loadToken();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error during login: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await JwtStorage.deleteToken();
      _clearUserData();
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
    return isAuthenticated.value;
  }
}