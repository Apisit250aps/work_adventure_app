import 'package:get/get.dart';
import 'dart:math';
import 'package:work_adventure/controllers/character_controller.dart';

class TableController extends GetxController {
  final CharacterController characterController =
      Get.find<CharacterController>();
  final Random random = Random();

  // SPECIAL attributes
  late final Map<String, int> special;

  @override
  void onInit() {
    super.onInit();
    _initializeSpecialAttributes();
  }

  void _initializeSpecialAttributes() {
    special = {
      's': characterController.special.value.strength,
      'p': characterController.special.value.perception,
      'e': characterController.special.value.endurance,
      'c': characterController.special.value.charisma,
      'i': characterController.special.value.intelligence,
      'a': characterController.special.value.agility,
      'l': characterController.special.value.luck,
    };
  }

  int specialPercentage(int value) => value ~/ 100;
  int characterHP() => 100 + (special['e']! * 10);
  int characterStamina() => 100 + (special['s']! * 10);

  int rollDice() {
    int rollD21 = random.nextInt(21) + 1;
    if (rollD21 == 21) return rollD21 = 1000;
    return rollD21;
  }

  int specialRoll(String attribute) {
    if (!special.containsKey(attribute)) return 0;
    int specialDice = (random.nextInt(special[attribute]!) + 1) ~/ 10;
    int specialMain = special[attribute]!;
    int finalDice =
        specialDice + (specialDice * specialPercentage(special['l']!));
    return specialMain + finalDice;
  }

  int calculateEXP(int exp) {
    return exp + (exp * specialPercentage(specialRoll("i")));
  }

  int calculateCoin(int coin) {
    int finalCoin = coin + ((coin * specialPercentage(specialRoll("l"))) * 2);
    if (rollDice() + ((specialRoll("p"))) <= 25) {
      finalCoin ~/= 2;
    }
    return finalCoin;
  }

  int calculateDamage(int damage) {
    const baseReduction = 0.05;
    const maxReduction = 0.80;
    const scalingFactor = 0.025;
    const lateGameBoost = 1.5;

    double reductionPercentage = baseReduction +
        (maxReduction - baseReduction) *
            (1 - exp(-scalingFactor * special['s']!));

    if (special['s']! >= 80) {
      double lateGameMultiplier =
          1 + (special['s']! - 80) / 20 * (lateGameBoost - 1);
      reductionPercentage *= lateGameMultiplier;
    }

    reductionPercentage =
        reductionPercentage.clamp(baseReduction, maxReduction);
    return (damage * (1 - reductionPercentage)).toInt();
  }
}
