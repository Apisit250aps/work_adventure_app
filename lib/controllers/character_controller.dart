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
        'assets/images/characters/wizard.png',
        'assets/images/characters/cat_sit.png',
        'assets/images/characters/dog.png',
        'assets/images/characters/knight1.png',
        'assets/images/characters/knight2.png',
        'assets/images/characters/steve.png',
        'assets/images/characters/monkey.png',
        'assets/images/characters/john.png',
        'assets/images/characters/cat.png',
        'assets/images/characters/chicky.png',
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

  Future<bool> updateCharacter(Character character) async {
    isLoading.value = true;
    try {
      final String id = character.id as String;
      final String endpoint = "${_rest.updateCharacter}/$id";
      final response = await _apiService.put(endpoint, character.toJson());
      if (response.statusCode == 200) {
        loadCharacters();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCharacter(String id) async {
    isLoading.value = true;
    try {
      final String endpoint = "${_rest.deleteCharacter}/$id";
      await _apiService.delete(endpoint);
    } catch (e) {
      throw Error();
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
    const double C = 13000;

    return (log(exp / C + 1) / log(base) + 1).toInt();
  }

  int get currentExp => characterSelect.value.exp as int;

  (int, int) calculateExpForNextLevel(int exp) {
    const double base = 1.045;
    const double C = 13000;

    int totalExp = currentExp + exp;
    int currentLevel = calculateLevel(currentExp);
    int expNextLevel = (C * (pow(base, currentLevel) - 1)).toInt();
    int expCurrentLevel = (C * (pow(base, currentLevel - 1) - 1)).toInt();
    int expForNextLevel = expNextLevel - expCurrentLevel;
    int expGap = totalExp - expCurrentLevel;
    print("ทดสอบๆ $expGap $expForNextLevel $currentLevel");
    print("$totalExp $expCurrentLevel");
    print("EXP : $currentExp");
    print(characterSelect.value.toJson());
    print(calculateLevel(900));

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
    print("เพิ่ม special +3");
    Character updatedCharacter = characterSelect.value.copyWith();
    updatedCharacter = updatedCharacter.copyWith(
        statusPoint: (updatedCharacter.statusPoint ?? 0) + 3);
    characterSelect.value = updatedCharacter;
    updateCharacterOnServer();
  }

  void additionalFocus() {
    print("เพิ่ม focus +1");
    Character updatedCharacter = characterSelect.value.copyWith();
    updatedCharacter = updatedCharacter.copyWith(
        statusPoint: (updatedCharacter.focusPoint ?? 0) + 1);
    characterSelect.value = updatedCharacter;
    updateCharacterOnServer();
  }

  bool isLevelup(int expInput) {
    final (expGap, expForNextLevel) = calculateExpForNextLevel(expInput);
    if (expGap >= expForNextLevel) {
      print("level up");
      additionalSpecial();
      print(characterSelect.value.toJson());
      return true;
    }
    return false;
  }

  bool focusSender(int exp, int coin) {
    print("ส่งค่า $exp");
    print("ส่งค่า $coin");
    additionalExp(exp);
    additionalCoins(coin);
    return true;
  }

  bool taskAdditional(int exp, int coin) {
    print("เพิ่มค่า $exp");
    additionalExp(exp);
    print("เพิ่มค่า $coin");
    additionalCoins(coin);
    if (isLevelup(exp)) {
      return true;
    }
    return false;
  }

  bool taskReduced(int exp, int coin) {
    print("เพิ่มค่า ${-exp}");
    additionalExp(-exp);
    print("เพิ่มค่า ${-coin}");
    additionalCoins(-coin);
    return true;
  }
}
