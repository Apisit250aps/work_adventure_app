import 'package:get/get.dart';
import 'package:work_adventure/controllers/table_controller.dart';
import 'package:work_adventure/controllers/focus_controller.dart';
import 'package:work_adventure/controllers/character_controller.dart';

class CharacterbarController extends GetxController {
  final TableController _tableController = Get.find<TableController>();
  final FocusController _focusController = Get.find<FocusController>();
  final CharacterController _characterController =
      Get.find<CharacterController>();

  (int, int) healthBar() {
    int maxHealth = _tableController.calculateCharacterHP();
    int damage = (_focusController.damageInput).toInt();
    int healthNow = (maxHealth - damage).clamp(0, maxHealth);

    return (healthNow, maxHealth);
  }

  (int, int) expBar() {
    final (exp, nextLevelExp) = _characterController.expExport();
    int currentExp = exp + (_focusController.expInput).toInt();
    return (currentExp, nextLevelExp);
  }
}
