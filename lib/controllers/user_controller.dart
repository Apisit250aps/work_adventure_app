import 'package:get/get.dart';
import 'package:work_adventure/models/character_model.dart';
import 'package:work_adventure/models/user_model.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:work_adventure/utils/jwt_storage.dart';

class UserStats {
  final int totalFocusPoint;
  final int totalCoin;
  final String userId;
  final int totalPoints;
  final String username;

  UserStats({
    required this.totalFocusPoint,
    required this.totalCoin,
    required this.userId,
    required this.totalPoints,
    required this.username,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
        totalFocusPoint: json['totalFocusPoint'] as int,
        totalCoin: json['totalCoin'] as int,
        userId: json['userId'] as String,
        totalPoints: json['totalPoints'] as int,
        username: json['username'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'totalFocusPoint': totalFocusPoint,
      'totalCoin': totalCoin,
      'userId': userId,
      'totalPoints': totalPoints,
      'username': username,
    };
  }
}

class UserController extends GetxController {
  final RestServiceController _rest = Get.find();
  final ApiService _apiService = Get.find();

  final RxString token = ''.obs;
  final Rx<User?> user = Rx<User?>(null);
  final RxList<Character> characters = <Character>[].obs;
  final RxBool isAuthenticated = false.obs;
  final RxBool isLoading = true.obs;
  final Rx<List<UserStats>> ranking = Rx<List<UserStats>>([]);
  UserStats? get currentUserStats => ranking.value.firstWhere(
        (stats) => stats.userId == user.value?.id,
        orElse: () => UserStats(
          totalFocusPoint: 0,
          totalCoin: 0,
          userId: user.value!.id as String,
          totalPoints: 0,
          username: '',
        ),
      );
  @override
  void onInit() {
    super.onInit();
    ever(isAuthenticated, _handleAuthChanged);
    _loadToken();
    loadRanking();
  }

  double calculateScore(UserStats stats) {
    return stats.totalFocusPoint * (stats.totalCoin * 0.2);
  }

  // ฟังก์ชันเรียงลำดับ ranking
  void sortRanking() {
    ranking.value.sort((a, b) {
      double scoreA = calculateScore(a);
      double scoreB = calculateScore(b);
      return scoreB.compareTo(scoreA); // เรียงจากมากไปน้อย
    });
    ranking.refresh(); // แจ้ง UI ให้อัพเดต
  }

  void _handleAuthChanged(bool isAuth) {
    if (isAuth) {
      Get.offAllNamed('/characters');
    } else {
      Get.offAllNamed('/login');
    }
  }

  Future<void> loadRanking() async {
    isLoading.value = true;
    try {
      final String endpoint = _rest.userRanking;
      final response = await _apiService.get(endpoint);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        ranking.value =
            jsonData.map((json) => UserStats.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load ranking data');
      }
    } catch (e) {
      print("Error loading ranking: $e");
      // You might want to update an error state here instead of throwing
      // errorState.value = true;
    } finally {
      sortRanking();
      isLoading.value = false;
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

  Future<int> register(String email, String username, String password) async {
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
      return response.statusCode;
    } catch (e) {
      print('Error during registration: $e');
      throw Error;
    }
  }

  Future<int> login(String username, String password) async {
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
        }
      }
      return response.statusCode;
    } catch (e) {
      print('Error during login: $e');
      throw Error;
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
