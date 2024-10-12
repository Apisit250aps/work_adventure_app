import 'package:get/get.dart';
import 'dart:math';
import 'package:work_adventure/controllers/character_controller.dart';

class TableController extends GetxController {
  final CharacterController _characterController =
      Get.find<CharacterController>();
  final Random _random = Random();

  late final Map<String, int> special;

  @override
  void onInit() {
    super.onInit();
    _initializeSpecialAttributes();
  }

  void _initializeSpecialAttributes() {
    final characterSpecial = _characterController.special.value;
    special = {
      's': characterSpecial.strength,
      'p': characterSpecial.perception,
      'e': characterSpecial.endurance,
      'c': characterSpecial.charisma,
      'i': characterSpecial.intelligence,
      'a': characterSpecial.agility,
      'l': characterSpecial.luck,
    };
  }

  int percentage(int value) => (value / 100).round();

  int characterHP() => (special['e']! * 10) + special['s']! ~/ 2;

  int characterStamina() => (special['s']! ~/ 2).clamp(5, 50);

  //ทอยลูกเต๋า
  int rollDice() {
    final count = (special['c']! ~/ 21).clamp(1, 3);
    return List.generate(count, (_) => singleDiceRoll())
        .reduce((a, b) => a == 0 && b != 100
            ? 0
            : a == 0 && b == 100
                ? 20
                : a > b
                    ? a
                    : b);
  }

  int singleDiceRoll() {
    final roll = _random.nextInt(21) + 1;
    return roll == 21
        ? 100
        : roll == 1
            ? 0
            : roll;
  }

  int specialRoll(String attribute) {
    if (!special.containsKey(attribute)) return 0;
    final specialDice = (_random.nextInt(21) / 10).round();
    return special[attribute]! + specialDice;
  }
  //----------------------------------------------------------------

  //คำนวณการได้ EXP
  int calculateEXP(int exp) {
    return exp + (exp * percentage(specialRoll('i')));
  }
  //----------------------------------------------------------------

  //คำนวณการได้ coins
  int calculateCoin(int coin) {
    final luckBonus = percentage(specialRoll('l'));
    int finalCoin = coin + ((coin * luckBonus) ~/ 0.65);

    if (_shouldReduceCoin()) {
      finalCoin ~/= 3;
    }
    return finalCoin;
  }

  bool _shouldReduceCoin() {
    final threshold = 12 + (_characterController.calculateLevel() ~/ 3);
    return rollDice() + specialRoll('p') <= threshold;
  }
  //----------------------------------------------------------------

  //คำนวณการลด Damage
  int calculateDamage(int damage) {
    const baseReduction = 0.05;
    const maxReduction = 0.80;
    const scalingFactor = 0.025;
    const lateGameBoost = 1.5;

    final strengthRoll = specialRoll('s');
    double reductionPercentage = _calculateBaseReduction(
        strengthRoll, baseReduction, maxReduction, scalingFactor);

    if (special['s']! >= 80) {
      reductionPercentage *=
          _calculateLateGameMultiplier(strengthRoll, lateGameBoost);
    }

    reductionPercentage =
        reductionPercentage.clamp(baseReduction, maxReduction);
    return (damage * (1 - reductionPercentage)).toInt();
  }

  double _calculateBaseReduction(int strengthRoll, double baseReduction,
      double maxReduction, double scalingFactor) {
    return baseReduction +
        (maxReduction - baseReduction) *
            (1 - exp(-scalingFactor * strengthRoll));
  }

  double _calculateLateGameMultiplier(int strengthRoll, double lateGameBoost) {
    return 1 + (strengthRoll - 80) / 20 * (lateGameBoost - 1);
  }
}

//----------------------------------------------------------------