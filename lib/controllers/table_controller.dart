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

  int percentage(int value) => (value / 100).round();
  int characterHP() => (special['e']! * 10) + (special['s']! ~/ 2);
  int characterStamina() => (special['s']! * 10);

  int rollDice() {
    int count = (special['c']! + special['l']!) ~/ 21;
    final random = Random();
    List<int> rolls = List.generate(count, (_) {
      int roll = random.nextInt(21) + 1;
      return (roll == 21) ? 100 : roll;
    });

    return rolls.reduce((a, b) => a > b ? a : b);
  }

  int specialRoll(String attribute) {
    if (!special.containsKey(attribute)) return 0;
    int specialDice = (random.nextInt(special[attribute]!) / 10).round();
    int specialMain = special[attribute]!;
    return specialMain + specialDice;
  }

  int calculateEXP(int exp) {
    return exp + (exp * percentage(specialRoll("i")));
  }

  int calculateCoin(int coin) {
    int finalCoin = coin + ((coin * percentage(specialRoll("l"))) * 2);
    if (rollDice() + ((specialRoll("p"))) <=
        10 + (characterController.calculateLevel()) ~/ 2) {
      finalCoin ~/= 3;
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
            (1 - exp(-scalingFactor * specialRoll("s")));

    if (special['s']! >= 80) {
      double lateGameMultiplier =
          1 + (specialRoll("s") - 80) / 20 * (lateGameBoost - 1);
      reductionPercentage *= lateGameMultiplier;
    }

    reductionPercentage =
        reductionPercentage.clamp(baseReduction, maxReduction);
    return (damage * (1 - reductionPercentage)).toInt();
  }
}
