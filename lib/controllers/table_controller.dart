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

  // ฟังก์ชันยูทิลิตี้
  int _percentage(int value) => (value / 100).round();

  double get _levelMultiplier =>
      pow(1.1, _characterController.calculateLevel() / 10) * 10;

  // สถานะตัวละคร
  int calculateCharacterHP() => special['e']! * 10 + special['s']! ~/ 2;
  int calculateCharacterStamina() => (special['s']! ~/ 2).clamp(5, 50);

  // การทอยลูกเต๋า
  int rollDice() {
    final count = (special['c']! ~/ 21).clamp(1, 3);
    return List.generate(count, (_) => singleDiceRoll())
        .reduce((a, b) => _compareDiceRolls(a, b));
  }

  int singleDiceRoll() {
    final roll = _random.nextInt(21) + 1;
    return roll == 21
        ? 100
        : roll == 1
            ? 0
            : roll;
  }

  int _compareDiceRolls(int a, int b) {
    if (a == 0 && b != 100) return 0;
    if (a == 0 && b == 100) return 20;
    return a > b ? a : b;
  }

  int specialRoll(String attribute) {
    if (!special.containsKey(attribute)) return 0;
    final specialDice = (_random.nextInt(21) / 10).round();
    return special[attribute]! + specialDice;
  }

  // การคำนวณประสบการณ์
  int calculateEXP(int exp) =>
      ((exp + (exp * _percentage(specialRoll('i')))) * _levelMultiplier)
          .round();

  // การคำนวณเหรียญ
  int calculateCoin(int coin, int difficulty) {
    final luckBonus = _percentage(specialRoll('l'));
    int coinBase = (coin * _levelMultiplier).round();
    int finalCoin = coinBase + ((coinBase * luckBonus) ~/ 0.65);

    if (_shouldReduceCoin(difficulty)) {
      finalCoin ~/= 3;
    }
    return finalCoin;
  }

  bool _shouldReduceCoin(int difficulty) {
    final threshold = (12 + (_levelMultiplier * (difficulty + 2))).round();
    return rollDice() + specialRoll('p') <= threshold;
  }

  // การคำนวณความเสียหาย
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

  // การคำนวณเควส
  (int, int) calculateQuest(int difficulty) {
    const questRewards = [
      [30, 50], // EXP, Coin สำหรับเควสธรรมดา
      [60, 150], // สำหรับเควสไม่ธรรมดา
      [120, 300], // สำหรับเควสหายาก
      [240, 600] // สำหรับเควสระดับเทพ
    ];

    int exp = (questRewards[difficulty][0] * _levelMultiplier).round();
    int gold = (questRewards[difficulty][1] * _levelMultiplier).round();

    int expReward = exp + (exp * _percentage(specialRoll("i")));
    int goldReward = gold + (gold * _percentage(specialRoll("c")));

    return (expReward, goldReward);
  }
}
