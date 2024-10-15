import 'package:get/get.dart';
import 'dart:math';
import 'package:work_adventure/controllers/character_controller.dart';

class TableController extends GetxController {
  final CharacterController _characterController =
      Get.find<CharacterController>();
  final Random _random = Random();

  Map<String, int> special = {};

  TableController() {
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
  double _percentage(int value) => (value / 100);

  double get _levelMultiplier =>
      pow(1.1, _characterController.calculateLevel() / 5).toDouble() + 0.5;

  // สถานะตัวละคร
  int calculateCharacterHP() => special['e']! * 10 + special['s']! ~/ 2;
  int calculateCharacterStamina() => (special['s']! ~/ 2).clamp(5, 50);

  // การทอยลูกเต๋า
  int rollDice() {
    final count = (special['c']! ~/ 21).clamp(1, 3);
    int dice = singleDiceRoll();
    double specialRollPercentage = _percentage(specialRoll("l"));
    int totalRoll =
        (dice + (dice * specialRollPercentage).floor()).clamp(0, 21);

    return List.generate(count, (_) => totalRoll)
        .reduce((a, b) => _compareDiceRolls(a, b));
  }

  int singleDiceRoll() {
    int normalRoll = _random.nextInt(20) + 1;
    if (normalRoll == 21) return 100;
    if (normalRoll == 1) return 0;
    return normalRoll;
  }

  int _compareDiceRolls(int a, int b) {
    if (a == 0 && b != 100) return 0;
    if (a == 0 && b == 100) return 20;
    return a > b ? a : b;
  }

  int specialRoll(String attribute) {
    if (!special.containsKey(attribute)) return 0;
    final luckBonus = (special["l"]! ~/ 1.5);
    final specialDice =
        (_random.nextInt((special[attribute]! + luckBonus + 1)) / 10).round();
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

  // การคำนวณลดความเสียหาย
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

  // การคำนวณลดความเสียหาย
  int hpReduction(int damage) {
    int characterHP = calculateCharacterHP();
    return (characterHP - damage).clamp(0, double.infinity).toInt();
  }

  // การคำนวณเควส
  int selectQuest() {
    final int dice = singleDiceRoll();
    final int charismaQuest = specialRoll("c") ~/ 15;

    final List<int> difficultyLevels = [
      (1 + charismaQuest ~/ 2).clamp(1, 6),
      (3 + charismaQuest).clamp(3, 10),
      (12 - charismaQuest).clamp(4, 12),
      (5 - charismaQuest ~/ 2).clamp(1, 5)
    ];

    final List<int> sorted = List.from(difficultyLevels)..sort();

    int selectedChance = dice <= sorted[3]
        ? sorted[3]
        : dice <= sorted[2] + sorted[3]
            ? sorted[2]
            : dice <= sorted[1] + sorted[2]
                ? sorted[1]
                : sorted[0];

    return difficultyLevels.indexOf(selectedChance);
  }

  (int, int) questReward(int difficulty) {
    const questRewards = [
      [30, 50], // EXP, Coin สำหรับเควสธรรมดา
      [60, 150], // สำหรับเควสไม่ธรรมดา
      [120, 300], // สำหรับเควสหายาก
      [240, 600] // สำหรับเควสระดับเทพ
    ];

    int exp = (questRewards[difficulty][0] * _levelMultiplier).round();
    int gold = (questRewards[difficulty][1] * _levelMultiplier).round();

    int expReward = (exp + (exp * _percentage(specialRoll("i")))).round();
    int goldReward = (gold + (gold * _percentage(specialRoll("c")))).round();

    return (expReward, goldReward);
  }

  // การคำนวณศัตรู
  int enemyCount(int difficulty) {
    final agilityPerEnemy = specialRoll("a");
    final percentage = _percentage(agilityPerEnemy);
    final baseEnemyCount = 50 - (50 * percentage);
    final adjustedEnemyCount = baseEnemyCount ~/ (difficulty + 1);
    return adjustedEnemyCount.clamp(3, 50);
  }

  int getEnemyIndex(int questNumber, bool isActive) {
    final dice = singleDiceRoll().clamp(1, 100);
    final characterLevel = _characterController.calculateLevel() ~/ 20;

    // คำนวณโอกาสการเกิดศัตรูแต่ละประเภท
    final List<int> enemyChance = [
      (12 - characterLevel).clamp(7, 12), // Common
      (6 - characterLevel ~/ 1.5).clamp(1, 6), // Uncommon
      (2 + characterLevel ~/ 1.5).clamp(2, 7), // Rare
      (1 + characterLevel).clamp(1, 6) // God
    ];

    if (isActive) {
      // ถ้าทอยลูกเต๋าได้ 11 หรือมากกว่า ให้ใช้ระดับเควสเป็นตัวกำหนด
      if (dice >= 11) {
        return questNumber;
      }
    }

    // เรียงลำดับโอกาสจากน้อยไปมาก
    final sorted = List.from(enemyChance)..sort();

    // เลือกประเภทศัตรูตามผลลูกเต๋า
    int selectedChance = dice <= sorted[3]
        ? sorted[3]
        : dice <= sorted[2] + sorted[3]
            ? sorted[2]
            : dice <= sorted[1] + sorted[2]
                ? sorted[1]
                : sorted[0];

    // หาดัชนีของประเภทศัตรูที่ถูกเลือก
    return enemyChance.indexOf(selectedChance);
  }

  // ความเร็วการเจอเหตุการณ์
  int timeEventRun() {
    int baseTimeEvent = 10;
    int agilityPerTime = (special["a"]! / 10).round();
    int timeEvent = (baseTimeEvent - agilityPerTime).clamp(2, 10);
    return timeEvent;
  }

  //เหตุการณ์พัก
  bool timeToRest(int counter) =>
      (counter == calculateCharacterStamina()) ? true : false;

  int restTimer() {
    int baseTimeRest = 10;
    int endurancePerTime = (special["e"]! ~/ 15);
    int timeRest =
        ((baseTimeRest - endurancePerTime) - (timeEventRun() + 1)).clamp(1, 10);
    return timeRest;
  }
}
