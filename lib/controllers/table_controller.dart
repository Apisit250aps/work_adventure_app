import 'package:get/get.dart';
import 'dart:math';
import 'package:work_adventure/controllers/character_controller.dart';

class TableController extends GetxController {
  final CharacterController characterController =
      Get.find<CharacterController>();
  final Random rd = Random();

  // SPECIAL attributes
  late final int strength;
  late final int perception;
  late final int endurance;
  late final int charisma;
  late final int intelligence;
  late final int agility;
  late final int luck;

  @override
  void onInit() {
    super.onInit();
    _initializeSpecialAttributes();
  }

  void _initializeSpecialAttributes() {
    strength = characterController.special.value.strength;
    perception = characterController.special.value.perception;
    endurance = characterController.special.value.endurance;
    charisma = characterController.special.value.charisma;
    intelligence = characterController.special.value.intelligence;
    agility = characterController.special.value.agility;
    luck = characterController.special.value.luck;
  }

  int specialPercentage(int value) => (value ~/ 100);

  int rollDice() => rd.nextInt(100) + 1;

  int characterHP() {
    const int baseHp = 100;
    return baseHp + (endurance * 10);
  }

  int characterStamina() {
    const int baseStamina = 100;
    return baseStamina + (strength * 10);
  }

  int calculateEXP(int exp) {
    return exp + (exp * specialPercentage(intelligence));
  }

  int calculateCoin(int coin) {
    int finalCoin = (coin + ((coin * specialPercentage(luck)) * 5));

    if (rollDice() + (perception ~/ 2) <= 49) {
      finalCoin ~/= 5;
    }

    return finalCoin;
  }

  int calculateDamage(int damage) {
    const double baseReduction = 0.1;
    const double maxReduction = 0.90;
    const double scalingFactor = 15;

    double damageReductionPercentage = baseReduction +
        (log(strength + 1) / log(scalingFactor)) *
            (maxReduction - baseReduction);

    damageReductionPercentage =
        damageReductionPercentage.clamp(baseReduction, maxReduction);

    return (damage * (1 - damageReductionPercentage)).toInt();
  }
}
