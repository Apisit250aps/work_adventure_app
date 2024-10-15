import 'dart:convert';
import 'dart:math';
import 'package:get/get.dart';
import 'package:work_adventure/models/character_model.dart';
import 'package:work_adventure/models/spacial_model.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';

class CharacterController extends GetxController {
  final RestServiceController _rest = Get.find();
  final ApiService _apiService = Get.find();
  final RxList<Character> charactersSlot = <Character>[].obs;
  final Rx<Character> characterSelect = const Character().obs;

  final Rx<Special> special = Rx<Special>(Special(
    id: "",
    charId: "",
    strength: 1,
    perception: 5,
    endurance: 1,
    charisma: 3,
    intelligence: 3,
    agility: 100,
    luck: 20,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ));

  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCharacters();
  }

  @override
  void onReady() {
    super.onReady();
    print('onReady called');
    // ใช้งานหลังจาก widget ถูกสร้างเสร็จแล้ว
  }

  @override
  void onClose() {
    print('onClose called');
    // ทำงานล้างข้อมูลเมื่อปิด widget
    super.onClose();
  }

  void selectIndex(int index) {
    characterSelect.value = charactersSlot[index];
    print(characterSelect);
  }

  Future<void> loadCharacters() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      charactersSlot.value = await fetchCharacter();
    } catch (e) {
      errorMessage.value = 'Failed to load characters: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Character>> fetchCharacter() async {
    final response = await _apiService.get(_rest.character);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((json) => Character.fromJson(json as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to fetch characters: ${response.statusCode}');
  }

  Future<bool> createCharacter(
    String name,
    String className,
    int avatarIndex,
  ) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await _apiService.post(
        _rest.createCharacter,
        {
          'name': name,
          'className': className,
          "avatarIndex": avatarIndex,
        },
      );

      if (response.statusCode == 201) {
        await loadCharacters();
        return true;
      }
      throw Exception('Failed to create character: ${response.statusCode}');
    } catch (e) {
      errorMessage.value = 'Failed to create character: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  int calculateLevel() {
    int exp = (characterSelect.value.exp as int);
    const double base = 1.045;
    const double C = 10000;

    int level = (log(exp / C + 1) / log(base) + 1).round();
    return level;
  }

  (int, int) expExport() {
    const double base = 1.045;
    const double C = 10000;
    int level = calculateLevel() + 1;
    int expNow = (characterSelect.value.exp as int);
    int expNextLevel = (C * (exp((level - 1) * log(base)) - 1)).round();

    return (expNow, expNextLevel);
  }
}
