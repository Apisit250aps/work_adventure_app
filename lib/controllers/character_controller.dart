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
    strength: 10,
    perception: 5,
    endurance: 1,
    charisma: 3,
    intelligence: 3,
    agility: 100,
    luck: 20,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  ));

  List<String> get characterImages => <String>[
        'assets/images/characters/cat.png',
        'assets/images/characters/dog.png',
        'assets/images/characters/john.png',
        'assets/images/characters/monkey.png',
        'assets/images/characters/steve.png',
      ];

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

  Future<void> updateCharacterOnServer() async {
    try {
      String path = _rest.updateCharacter;
      String endpoints = "$path/${characterSelect.value.id}";
      print(characterSelect.value.toJson());
      final response = await _apiService.put(
        endpoints,
        characterSelect.value.toJson(),
      );

      if (response.statusCode == 200) {
        print("Special updated successfully on server");
      } else {
        print(
            "Failed to update special on server. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating special on server: $e");
      // You might want to show an error message to the user here
    }
  }

  int calculateLevel(int exp) {
    const double base = 1.045;
    const double C = 10000;

    return (log(exp / C + 1) / log(base) + 1).round();
  }

  int get currentExp => characterSelect.value.exp as int;

  (int, int) calculateExpForNextLevel(int add) {
    const double base = 1.045;
    const double C = 10000;

    int totalExp = currentExp + add;
    int currentLevel = calculateLevel(currentExp);
    int expNextLevel = (C * (pow(base, currentLevel) - 1)).round();
    int expCurrentLevel = (C * (pow(base, currentLevel - 1) - 1)).round();
    int expForNextLevel = expNextLevel - expCurrentLevel;
    int expGap = totalExp - expCurrentLevel;
    print("ทดสอบๆ ${expGap} ${expForNextLevel} ${currentLevel + 1}");

    return (expGap, expForNextLevel);
  }

  void additionalExp(int add) {
    Character updatedCharacter = characterSelect.value.copyWith();
    updatedCharacter =
        updatedCharacter.copyWith(exp: (updatedCharacter.exp ?? 0) + add);

    characterSelect.value = updatedCharacter;
    updateCharacterOnServer();
  }

  void additionalCoins(int add) {
    Character updatedCharacter = characterSelect.value.copyWith();
    updatedCharacter =
        updatedCharacter.copyWith(coin: (updatedCharacter.coin ?? 0) + add);

    characterSelect.value = updatedCharacter;
    updateCharacterOnServer();
  }

  void additionalSpecial() {
    Character updatedCharacter = characterSelect.value.copyWith();
    updatedCharacter = updatedCharacter.copyWith(
        focusPoint: (characterSelect.value.statusPoint ?? 0) + 3);
    characterSelect.value = updatedCharacter;
    updateCharacterOnServer();
  }

  bool isLevelup(int expInput) {
    final (expGap, expForNextLevel) = calculateExpForNextLevel(expInput);
    if (expGap >= expForNextLevel) {
      print("level up");
      additionalSpecial();
      return true;
    }
    return false;
  }

  bool focusSender(int exp, int coin) {
    if (isLevelup(exp)) {
      additionalExp(exp);
      additionalCoins(coin);
      return true;
    }

    return false;
  }

  bool taskSender(int exp, int coin) {
    additionalExp(exp);
    additionalCoins(coin);
    if (isLevelup(exp)) {
      return true;
    }
    return false;
  }
}
