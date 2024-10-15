import 'package:get/get.dart';
import 'package:work_adventure/controllers/table_controller.dart';

class CharacterbarController extends GetxController {
  final TableController _tableController = Get.find<TableController>();

  int damageInput = 10;

  (int, int) healthBar() {
    int maxHealth = _tableController.calculateCharacterHP();
    int damage = 10;

    int healthNow = maxHealth - damage;

    return (healthNow, maxHealth);
  }
}
