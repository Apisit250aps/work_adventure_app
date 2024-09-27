import 'dart:convert';

import 'package:get/get.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:work_adventure/models/character_statistic_model.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';

class CharacterController extends GetxController {
  final UserController user = Get.find();
  final RestServiceController _rest = Get.find();
  final ApiService _apiService = Get.find();

  // Observable list to store the characters
  var charactersSlot = <Character>[].obs;

  // Observable integer to keep track of selected character index
  var characterSelect = 0.obs;

  // Safe getter for selected character
  Character get character => charactersSlot[characterSelect.value];

  @override
  void onInit() {
    super.onInit();
    // เรียกใช้ฟังก์ชันเพื่อโหลดตัวละครจากที่เก็บข้อมูลหรือ API
    loadCharacters();
  }

  void loadCharacters() async {
    charactersSlot.value = await fetchCharacter();
  }

  Future<List<Character>> fetchCharacter() async {
    try {
      final response = await _apiService.get(_rest.myCharacters);
      if (response.statusCode == 200) {
        // แปลง response.body เป็น List<dynamic> ก่อน
        final List<dynamic> jsonData = jsonDecode(response.body);

        // แปลงแต่ละ element ใน List ให้เป็น Character
        return jsonData
            .map((json) => Character.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return <Character>[]; // คืนค่าเป็น List ว่างถ้าสถานะไม่ใช่ 200
    } catch (e) {
      // จัดการ error และคืนค่าเป็น List ว่าง
      return <Character>[];
    }
  }

  Future<bool> createCharacter(String name, String className) async {
    try {
      final response = await _apiService.post(
        _rest.createCharacter,
        jsonEncode({
          'name': name,
          'className': className,
        }),
      );

      if (response.statusCode == 201) {
        // เมื่อสำเร็จให้��หลดข้อมูลใหม่
        loadCharacters();
        return true;
      }
      return false;
    } catch (e) {
      // จัดการ error
      return false;
    }
  }
}
