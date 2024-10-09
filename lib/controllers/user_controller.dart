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

  var token = ''.obs;
  final Rx<User?> user = null.obs;
  var characters = <Character>[].obs;
  final RxBool isAuthenticated = true.obs;
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
    print(isAuthenticated.value);
    print(isLoading.value);
    print(user);
  }

  @override
  void onClose() {
    print('onClose called');
    isLoading.value = false;
    super.onClose();
  }

  void _loadToken() async {
    isLoading.value = true;
    final String? tokenStore = await JwtStorage.getToken();
    if (tokenStore != null && tokenStore.isNotEmpty) {
      token.value = tokenStore;
      final User? userData = await fetchUser();
      user.value = userData!;

      if (user.value != null) {
        isAuthenticated.value = true;
      } else {
        isAuthenticated.value = false;
      }
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
        final userData = json.decode(response.body);
        return User.fromJson(userData[0]);
      }
      return null;
    } catch (e) {
      print('Error fetching user: $e');
      return null;
    }
  }

  Future<bool> checkAuthentication() async {
    try {
      return true;
    } catch (e) {
      return false;
    }
  }
}
