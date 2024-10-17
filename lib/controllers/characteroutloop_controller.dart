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
    int maxHealth = _tableController.calculateCharacterHP;
    int damage = (_focusController.damageInput).toInt();
    int healthNow = (maxHealth - damage).clamp(0, maxHealth);

    return (healthNow, maxHealth);
  }

  (int, int) expBar() {
    int expInput = (_focusController.expInput).toInt();
    int coinInput = (_focusController.coinInput).toInt();
    bool checkLevelUp = _characterController.focusSender(expInput, coinInput);
    final (expGap, expForNextLevel) =
        _characterController.calculateExpForNextLevel(expInput);
    if (checkLevelUp) {
      _focusController.expInputReset();
      _focusController.coinInputReset();
      return (((expGap).clamp(1, double.infinity)).toInt(), expForNextLevel);
    }

    return (((expGap)).clamp(1, double.infinity).toInt(), expForNextLevel);
  }

  (int, int) spBar() {
    int maxSP = _tableController.calculateCharacterStamina;
    int spNow = (maxSP - (_focusController.SPCounter).toInt()).clamp(0, maxSP);

    return (spNow, maxSP);
  }
}
