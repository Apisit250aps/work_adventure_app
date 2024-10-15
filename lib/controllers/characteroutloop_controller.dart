import 'package:get/get.dart';
import 'package:work_adventure/controllers/table_controller.dart';
import 'package:work_adventure/controllers/focus_controller.dart';

class CharacterbarController extends GetxController {
  final TableController _tableController = Get.find<TableController>();
  final FocusController _focusController = Get.find<FocusController>();

  (int, int) healthBar() {
    int maxHealth = _tableController.calculateCharacterHP();
    int damage = (_focusController.damageInput).toInt();
    int healthNow = maxHealth - damage;

    return (healthNow, maxHealth);
  }
}
