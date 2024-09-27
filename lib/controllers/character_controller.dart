import 'package:get/get.dart';
import 'package:work_adventure/models/character_statistic_model.dart';

class CharacterController extends GetxController {
  var characters = <Character>[].obs; // ใช้ observable list

  @override
  void onInit() {
    super.onInit();
    // เรียกใช้ฟังก์ชันเพื่อโหลดตัวละครจากที่เก็บข้อมูลหรือ API
    loadCharacters();
  }

  void loadCharacters() async {
    // สมมติว่าคุณมีฟังก์ชันเพื่อดึงตัวละครจาก API หรือฐานข้อมูล
    var fetchedCharacters = Character; // ฟังก์ชันนี้ต้องสร้างขึ้น
  }

  // ฟังก์ชันเพื่อเพิ่มตัวละคร
  void addCharacter(Character character) {
    characters.add(character);
  }

  // ฟังก์ชันเพื่อแก้ไขตัวละคร
  void updateCharacter(int index, Character character) {
    characters[index] = character;
  }

  // ฟังก์ชันเพื่อลบตัวละคร
  void removeCharacter(int index) {
    characters.removeAt(index);
  }
}
