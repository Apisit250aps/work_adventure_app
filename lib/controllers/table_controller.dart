import 'package:get/get.dart';
import 'dart:math';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/special_controller.dart';
import 'package:work_adventure/models/spacial_model.dart';

class TableController extends GetxController {
  final CharacterController _characterController =
      Get.find<CharacterController>();
  final SpecialController _specialController = Get.find<SpecialController>();
  final Random _random = Random();

  Rx<Map<String, int>> special = Rx<Map<String, int>>({});

  @override
  void onInit() {
    super.onInit();
    ever(_specialController.special, _updateSpecial);
    _updateSpecial(_specialController.special.value);
  }

  _updateSpecial(Special specialValue) {
    special.value = {
      's': specialValue.strength,
      'p': specialValue.perception,
      'e': specialValue.endurance,
      'c': specialValue.charisma,
      'i': specialValue.intelligence,
      'a': specialValue.agility,
      'l': specialValue.luck,
    };
  }

  // ฟังก์ชันยูทิลิตี้
  double _percentage(int value) => (value / 100);

  double get levelMultiplier =>
      pow(1.15, _characterController.calculateLevel(0) / 5).toDouble() + 0.5;

  // สถานะตัวละคร
  int get calculateCharacterHP =>
      (special.value['e']! * 10 + special.value['s']!);

  int get calculateCharacterStamina =>
      ((special.value['s']! + special.value['i']!) ~/ 4).clamp(5, 50);

  // การทอยลูกเต๋า
  int get rollDice {
    final count = (special.value['c']! ~/ 21).clamp(1, 3);
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
    if (!special.value.containsKey(attribute)) return 0;
    final luckBonus = (special.value["l"]! ~/ 10);
    final specialDice =
        (_random.nextInt((special.value[attribute]! + luckBonus + 1)) / 10)
            .round();
    return special.value[attribute]! + specialDice;
  }

  // การคำนวณประสบการณ์
  int calculateEXP(int exp) => ((exp +
              ((exp * (specialRoll('i') / 10)) *
                  _percentage(specialRoll('i')))) *
          levelMultiplier)
      .round();

  double get expIncreasePercentage {
    double intmultiplier = (special.value["i"]! / 10).clamp(1, 10) * 100;
    double intPercentage = _percentage(special.value["i"]!);
    return intmultiplier + intPercentage - 100;
  }

  // การคำนวณเหรียญ
  int calculateCoin(int coin, int difficulty) {
    final luckBonus = _percentage(specialRoll('l'));
    int coinBase = (coin * levelMultiplier).round();
    int finalCoin = coinBase + ((coinBase * luckBonus) ~/ 0.65);

    if (_shouldReduceCoin(difficulty)) {
      finalCoin ~/= 3;
    }
    return finalCoin;
  }

  bool _shouldReduceCoin(int difficulty) {
    final threshold = (12 + (levelMultiplier * (difficulty + 2))).round();
    return rollDice + specialRoll('p') >= threshold;
  }

  // การคำนวณลดความเสียหาย
  int calculateDamage(int damage) {
    const baseReduction = 0.05;
    const maxReduction = 0.80;
    const scalingFactor = 0.025;
    const lateGameBoost = 1.5;

    final physicalRoll = specialRoll('s') ~/ 1.5;
    double reductionPercentage = _calculateBaseReduction(
        physicalRoll, baseReduction, maxReduction, scalingFactor);

    if (special.value['s']! >= 80) {
      reductionPercentage *=
          _calculateLateGameMultiplier(physicalRoll, lateGameBoost);
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
    int characterHP = calculateCharacterHP;
    return (characterHP - damage).clamp(0, double.infinity).toInt();
  }

  // การคำนวณเควส
  int get selectQuest {
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
      [40, 70], // EXP, Coin สำหรับเควสธรรมดา
      [80, 210], // สำหรับเควสไม่ธรรมดา
      [160, 420], // สำหรับเควสหายาก
      [320, 840] // สำหรับเควสระดับเทพ
    ];

    int exp = (questRewards[difficulty][0] * levelMultiplier).round();
    int gold = (questRewards[difficulty][1] * levelMultiplier).round();

    int expReward = (exp + (exp * _percentage(specialRoll("i")))).round();
    int goldReward = (gold + (gold * _percentage(specialRoll("c")))).round();

    return (expReward, goldReward);
  }

  // การคำนวณศัตรู
  int enemyCount(int difficulty) {
    final agilityPerEnemy =
        ((specialRoll("c") * 1.5) + specialRoll("a")) ~/ 2.5;
    final percentage = _percentage(agilityPerEnemy);
    final baseEnemyCount = 50 - (50 * percentage);
    final adjustedEnemyCount = baseEnemyCount ~/ (difficulty + 1);
    return adjustedEnemyCount.clamp(3, 50);
  }

  int getEnemyIndex(int questNumber, bool isActive) {
    final dice = singleDiceRoll().clamp(1, 100);
    final characterLevel = _characterController.calculateLevel(0) ~/ 10;

    // คำนวณโอกาสการเกิดศัตรูแต่ละประเภท
    final List<int> enemyChance = [
      (13 - characterLevel ~/ 1.5).clamp(7, 13), // Common
      (5 - characterLevel).clamp(1, 5), // Uncommon
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
  int get timeEventRun {
    int baseTimeEvent = 15;
    int agilityPerTime = ((special.value["a"]!) / 15).round();
    int timeEvent = (baseTimeEvent - agilityPerTime).clamp(2, 15);
    return timeEvent;
  }

  //เหตุการณ์พัก
  bool timeToRest(int counter) =>
      (counter > calculateCharacterStamina) ? true : false;

  int get restTimer {
    int baseTimeRest = 15;
    int endurancePerTime = (((specialRoll("e") + specialRoll("i"))) ~/ 15);
    int timeRest =
        ((baseTimeRest - endurancePerTime) - (timeEventRun + 1)).clamp(0, 20);
    return timeRest;
  }

  int get restHealing {
    double healPoint = ((rollDice / 2).clamp(0, 50) +
            (specialRoll("c") + (specialRoll("e"))) ~/ 2) *
        levelMultiplier;
    int totalHealing =
        (healPoint + (healPoint * _percentage(specialRoll("l")))).round();

    return totalHealing;
  }

  //เหตุการณ์ตาย
  bool healthReduceCondition(int damage) {
    if (calculateCharacterHP - damage <= 0) {
      return false;
    }
    return true;
  }

  int get timeTodie {
    int baseTime = 90;
    int timeEventDie = (((special.value["s"]! +
                    special.value["p"]! +
                    special.value["e"]! +
                    special.value["c"]! +
                    special.value["i"]! +
                    special.value["a"]! +
                    special.value["l"]!) ~/
                7) -
            7)
        .clamp(0, 93);
    int timeDie =
        ((baseTime - ((baseTime * _percentage(timeEventDie)).toInt())) -
                (timeEventRun + 1))
            .clamp(10, 90);
    return timeDie;
  }

  //เหตุการณ์เจอสมบัติ
  (int, int) itemReward(int difficulty) {
    const questRewards = [
      [10, 20], // EXP, Coin
      [20, 40],
      [40, 80],
      [80, 160]
    ];

    int exp = (questRewards[difficulty][0] * levelMultiplier).round();
    int gold = (questRewards[difficulty][1] * levelMultiplier).round();
    int expReward = calculateEXP(exp);
    int goldReward = calculateCoin(gold, difficulty);

    return (expReward, goldReward);
  }

  int randomItem() {
    int luckmultiplier = (specialRoll("l") ~/ 20).clamp(0, 5);
    final dice = singleDiceRoll().clamp(1, 100) + luckmultiplier;
    final characterLevel = _characterController.calculateLevel(0) ~/ 10;

    // คำนวณโอกาสการเกิดไอเทมแต่ละประเภท
    final List<int> itemChance = [
      (13 - characterLevel ~/ 1.5).clamp(7, 13), // Common
      (5 - characterLevel).clamp(1, 5), // Uncommon
      (2 + characterLevel).clamp(2, 7), // Rare
      (1 + characterLevel ~/ 1.5).clamp(1, 6) // God
    ];

    // เรียงลำดับโอกาสจากน้อยไปมาก
    final sorted = List.from(itemChance)..sort();

    // เลือกประเภทศัตรูไอเทมลูกเต๋า
    int selectedChance = dice <= sorted[3]
        ? sorted[3]
        : dice <= sorted[2] + sorted[3]
            ? sorted[2]
            : dice <= sorted[1] + sorted[2]
                ? sorted[1]
                : sorted[0];

    // หาดัชนีของประเภทไอเทมที่ถูกเลือก
    return itemChance.indexOf(selectedChance);
  }

  //รีเลือด
  int get healthRegeneration {
    int regeneration =
        (((special.value["a"]! * 1.5) + (special.value["i"]! / 1.5) / 3)
                .floor())
            .clamp(0, 400);
    return regeneration;
  }

  bool timeToRegenerate(int time) => (time == 5) ? true : false;

  //task Sender
  (int, int) taskSender(int difficulty) {
    int baseExp = 80;
    int baseCoin = 40;
    int totalExp =
        ((calculateEXP(baseExp) * difficulty) * levelMultiplier).round();
    int totalCoin =
        ((calculateCoin(baseCoin, -100) * difficulty) * levelMultiplier)
            .round();
    return (totalExp, totalCoin);
  }

  (int, int) questSender() {
    int baseExp = 50;
    int baseCoin = 25;
    int totalExp = (calculateEXP(baseExp) * levelMultiplier).round();
    int totalCoin = (calculateCoin(baseCoin, 0) * levelMultiplier).round();
    return (totalExp, totalCoin);
  }

  //สุ่มเหตุการณ์
  // void generateRandomEvent() {

  //     _generateNothingEvent();
  //     _generateEnemyEvent();
  //     _generateVillageEvent();

  // }
}
