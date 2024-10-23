import 'package:get/get.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/table_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class LogEntry {
  final String icon;
  final String title;
  final String description;
  final DateTime timestamp;

  LogEntry({
    required this.icon,
    required this.title,
    required this.description,
    required this.timestamp,
  });
}

class MonsterName {
  final String emoji;
  final String name;
  final Color color;

  MonsterName(this.emoji, this.name, this.color);

  @override
  String toString() => '$emoji $name';
}

class ItemName {
  final String emoji;
  final String name;
  final Color color;

  ItemName(this.emoji, this.name, this.color);

  @override
  String toString() => '$emoji $name';
}

class FocusController extends GetxController {
  // Controllers
  final CharacterController _characterController =
      Get.find<CharacterController>();
  final TableController _tableController = Get.find<TableController>();

  // Observable variables
  RxInt _timeRemaining = 600.obs;
  final RxInt _totalTime = 600.obs;
  final RxBool _isActive = false.obs;
  final RxList<LogEntry> _adventureLog = <LogEntry>[].obs;
  final RxString _currentEncounterIcon = "🌟".obs;
  final RxString _currentEncounterDescription =
      "รอการผจญภัย...\nใจเต้นระรัวความคาดหวังพลุ่งพล่าน".obs;
  final RxInt eventCount = 0.obs;
  final RxBool _showingSummary = false.obs;
  RxInt spCounter = 0.obs;
  RxInt regenerationCounter = 0.obs;
  RxInt focusCounter = 0.obs;
  RxBool mustSender = false.obs;
  final RxBool isResting = false.obs;
  final RxInt _restTimeRemaining = 0.obs;
  final RxBool isDead = false.obs;
  final RxInt deathTimeRemaining = 0.obs;
  RxInt damageInput = 0.obs;
  RxInt expInput = 0.obs;
  RxInt coinInput = 0.obs;

  RxInt runBar = 0.obs;
  RxInt dieBar = 0.obs;
  RxInt restBar = 0.obs;

  RxInt eventIntervalSeconds = 0.obs;
  RxInt restMaxBar = 0.obs;

  // Timers
  Timer? _timer;
  Timer? _eventTimer;
  Timer? _restTimer;
  Timer? _reviveTimer;

  // Other variables
  int rollOne = 0;
  String enemyQuestName = "";
  RxInt enemyQuestCounter = 0.obs;
  bool questIsActive = false;
  int questNumber = 21;
  int questGold = 0;
  int questExp = 0;
  int questEnemyNumber = 0;
  bool isRest = false;

  // Colors
  final Color commonColor = Colors.green;
  final Color uncommonColor = Colors.blue;
  final Color rareColor = Colors.purple;
  final Color epicColor = Colors.orange;

  late List<List<MonsterName>> enemy;

  // Getters
  int get totalTime => _totalTime.value;
  int get timeRemaining => _timeRemaining.value;
  bool get isActive => _isActive.value;
  List<LogEntry> get adventureLog => _adventureLog.toList();
  String get currentEncounterIcon => _currentEncounterIcon.value;
  String get currentEncounterDescription => _currentEncounterDescription.value;
  bool get showingSummary => _showingSummary.value;
  int get restDuration => _tableController.restTimer;
  int get _eventIntervalSeconds => _tableController.timeEventRun;

  late List<List<ItemName>> items;

  @override
  void onInit() {
    super.onInit();
    WakelockPlus.enable();
    restMaxBar.value = _tableController.restTimer;
    eventIntervalSeconds.value = _tableController.timeEventRun;
    _initializeEnemies();
    _initializeItems();
    _setupTableControllerListener();
  }

  void _initializeEnemies() {
    enemy = [
      [
        MonsterName("🐺", "หมาป่าจิ๋ว", commonColor),
        MonsterName("🦇", "ค้างคาวราตรี", commonColor),
        MonsterName("🐗", "หมูป่าพิฆาต", commonColor),
        MonsterName("🦊", "จิ้งจอกไฟ", commonColor),
        MonsterName("🐍", "อสรพิษ", commonColor)
      ],
      [
        MonsterName("🧟", "ซอมบี้ราชา", uncommonColor),
        MonsterName("💀", "โครงกระดูกอมตะ", uncommonColor),
        MonsterName("🧛", "แวมไพร์เลือดเย็น", uncommonColor),
        MonsterName("🐲", "มังกรไฟนรก", uncommonColor),
        MonsterName("🧙", "พ่อมดมรณะ", uncommonColor)
      ],
      [
        MonsterName("🐉", "มังกรทมิฬ", rareColor),
        MonsterName("💀", "ราชาลิชอนธการ", rareColor),
        MonsterName("🌑", "ปีศาจแห่งความมืด", rareColor),
        MonsterName("🧛🏻", "เจ้าแวมไพร์ไร้พ่าย", rareColor),
        MonsterName("🧙🏻", "จอมมารแห่งหายนะ", rareColor)
      ],
      [
        MonsterName("💀", "ราชันวิญญาณ", epicColor),
        MonsterName("⏳", "เทพแห่งกาลเวลา", epicColor),
        MonsterName("🗡️", "อัศวินแห่งความมืด", epicColor),
        MonsterName("🌙", "เทพจันทราและความฝัน", epicColor),
        MonsterName("🧙", "จอมเวทแห่งอนันต์", epicColor)
      ]
    ];
  }

  void _initializeItems() {
    items = [
      [
        ItemName("📦", "หีบไม้ผุ", commonColor),
        ItemName("👝", "ถุงหนังเก่า", commonColor),
        ItemName("🪙", "เหรียญขึ้นสนิม", commonColor),
        ItemName("💍", "แหวนทองหมอง", commonColor),
        ItemName("⛓️", "สร้อยเงินโบราณ", commonColor)
      ],
      [
        ItemName("🗃️", "หีบโลหะลึกลับ", uncommonColor),
        ItemName("🎒", "ถุงเวทมนตร์", uncommonColor),
        ItemName("💰", "เหรียญราชวงศ์", uncommonColor),
        ItemName("💎", "แหวนอัญมณีเรือง", uncommonColor),
        ItemName("🦪", "สร้อยมุกเรืองรอง", uncommonColor)
      ],
      [
        ItemName("🏺", "หีบทองคำโบราณ", rareColor),
        ItemName("🎇", "ถุงมังกร", rareColor),
        ItemName("🔶", "เหรียญจักรพรรดิ", rareColor),
        ItemName("👑", "แหวนราชันย์", rareColor),
        ItemName("🧬", "สร้อยไข่มุกวิเศษ", rareColor)
      ],
      [
        ItemName("⏳", "หีบแห่งกาลเวลา", epicColor),
        ItemName("🌌", "ถุงสารพัดนึก", epicColor),
        ItemName("🌟", "เหรียญเทพเจ้า", epicColor),
        ItemName("💫", "แหวนครองพิภพ", epicColor),
        ItemName("🔮", "สร้อยแห่งโชคชะตา", epicColor)
      ]
    ];
  }

  void _setupTableControllerListener() {
    ever(_tableController.special, (_) {
      if (_isActive.value) {
        _startEventTimer();
      }
    });
  }

  // Session management methods
  void initFocus(int minutes) {
    _totalTime.value = minutes * 60;
    _timeRemaining.value = _totalTime.value;
    _resetSessionState();
    _addLogEntry("🏁", "Adventure Start", "Your journey begins!");
  }

  void toggleActive() {
    _isActive.toggle();
    if (_isActive.value) {
      _startSession();
    } else {
      pauseFocus();
    }
  }

  void _startSession() {
    _resetSessionVariables();
    _startTimer();
    _startEventTimer();
    _addLogEntry("🏁", "Adventure Start", "Your journey begins!");
  }

  void resetFocus() {
    pauseFocus();
    _timeRemaining.value = _totalTime.value;
    _resetSessionVariables();
    _resetQuestVariables();
    _addLogEntry("🔄", "Reset", "Your adventure has been reset.");
  }

  void pauseFocus() {
    _stopTimers();
    _isActive.value = false;
    isResting.value = false;
    isDead.value = false;
  }

  void _resetSessionVariables() {
    _adventureLog.clear();
    _currentEncounterIcon.value = "🌟";
    _currentEncounterDescription.value =
        "รอการผจญภัย...\nใจเต้นระรัวความคาดหวังพลุ่งพล่าน";
    eventCount.value = 0;
    _showingSummary.value = false;
    spCounter.value = 0;
    regenerationCounter.value = 0;
    focusCounter.value = 0;
    mustSender.value = false;
    _restTimeRemaining.value = 0;
    deathTimeRemaining.value = 0;
    damageInput.value = 0;
    expInput.value = 0;
    coinInput.value = 0;
    runBar = 0.obs;
    dieBar = 0.obs;
    restBar = 0.obs;
  }

  void _resetQuestVariables() {
    enemyQuestName = "";
    enemyQuestCounter.value = 0;
    questIsActive = false;
    questNumber = 21;
    questGold = 0;
    questExp = 0;
    questEnemyNumber = 0;
    isRest = false;
  }

  void _stopTimers() {
    _timer?.cancel();
    _eventTimer?.cancel();
    _restTimer?.cancel();
    _reviveTimer?.cancel();
  }

  void showSummary() {
    _showingSummary.value = true;
    _addLogEntry("🏁", "Summary", "Adventure completed!");
  }

  // Timer methods
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _timeRemaining--;

      if (isDead.value) {
        dieBar++;
      } else {
        dieBar.value = 0;
      }
      if (isResting.value) {
        restBar++;
      } else {
        restBar.value = 0;
      }

      if (!isDead.value && !isResting.value) {
        runBar++;
      }

      if (runBar.value >= _eventIntervalSeconds) {
        runBar.value = 0;
      }

      if (_timeRemaining.value <= 0) {
        mustSender.value = true;
      }
      updateServerSystem();
      focusSystem();
      if (_timeRemaining.value > 0) {
        generationSystem();
      } else {
        _endSession();
      }
    });
  }

  void updateServerSystem() {
    if (_characterController.isLevelup(expInput.value) || mustSender.value) {
      _characterController.focusSender(expInput.value, coinInput.value);
      expInputReset();
      coinInputReset();
      mustSenderReset();
    }
  }

  void focusSystem() {
    focusCounter++;
    if (focusCounter.value >= 600) {
      _characterController.additionalFocus();
      focusCounterReset();
    }
  }

  void generationSystem() {
    regenerationCounter++;
    if (_tableController.timeToRegenerate(regenerationCounter.value)) {
      if (!isDead.value && !isResting.value) {
        print("Regeneration is working");
        damageInput.value -=
            _tableController.healthRegeneration.clamp(0, damageInput.value);
        print("damge after: ${damageInput.value} ");
      }
      regenerationCounter.value = 0;
    }
  }

  void _startEventTimer() {
    _eventTimer?.cancel();
    if (isDead.value) {
      isDead.value = false;
      damageInput.value ~/= 2;
      spCounter.value = 0;
    }
    _eventTimer = Timer.periodic(Duration(seconds: _eventIntervalSeconds), (_) {
      if (_isActive.value &&
          _timeRemaining.value > 0 &&
          isDead.value == false) {
        generateEvent();
      }
    });
  }

  void _startRestTimer() {
    _eventTimer?.cancel();
    _restTimer?.cancel();

    final totalStaminaToRecover = _tableController.calculateCharacterStamina;
    final staminaPerSecond = totalStaminaToRecover / restDuration;

    _restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_restTimeRemaining.value > 0) {
        int restTime = restDuration;
        _restTimeRemaining.value--;

        final elapsedTime = restTime - _restTimeRemaining.value;
        final recoveredStamina = (staminaPerSecond * elapsedTime).floor();

        spCounter.value = totalStaminaToRecover - recoveredStamina;
      } else {
        spCounter.value = 0;
        isResting.value = false;
        _restTimer?.cancel();
        _startEventTimer();
      }
    });
  }

  void _startReviveTimer() {
    _eventTimer?.cancel();
    _reviveTimer?.cancel();
    _reviveTimer = Timer(Duration(seconds: deathTimeRemaining.value), () {
      _reviveTimer?.cancel();

      _startEventTimer();
    });
  }

  void _endSession() {
    _resetQuestVariables();
    _resetSessionVariables();
    _stopTimers();
    _isActive.value = false;
    showSummary();
  }

  void _resetSessionState() {
    _isActive.value = false;
    isResting.value = false;
    _adventureLog.clear();
    _currentEncounterIcon.value = "🌟";
    _currentEncounterDescription.value = "รอการผจญภัย...\n";
    eventCount.value = 0;
    _showingSummary.value = false;
    spCounter.value = 0;
    _restTimeRemaining.value = 0;
  }

  void expInputReset() {
    expInput.value = 0;
  }

  void coinInputReset() {
    coinInput.value = 0;
  }

  void focusCounterReset() {
    focusCounter.value = 0;
  }

  void mustSenderReset() {
    mustSender.value = false;
  }

  // Event generation methods
  void generateEvent() {
    spCounter++;
    if (_tableController.timeToRest(spCounter.toInt())) {
      _generateRestEvent();
    } else {
      _generateRandomEvent();
    }
  }

  void _generateRandomEvent() {
    // ปรับโอกาสการเกิดเหตุการณ์ต่างๆ
    int runEvent = _tableController.generateRandomEvent();

    if (runEvent == 0) {
      _generateEnemyEvent();
    } else if (runEvent == 1) {
      _generateNothingEvent();
    } else if (runEvent == 2) {
      if (!questIsActive) {
        _generateVillageEvent();
      } else {
        _generateEnemyEvent();
      }
    } else {
      _generateTreasureEvent();
    }
  }

  void _generateVillageEvent() {
    questIsActive = true;
    final villageType = _getRandomVillageType();
    final questDifficulty = _tableController.selectQuest;
    questNumber = questDifficulty;
    final MonsterName questDescription = _getQuestDescription(questDifficulty);
    final enemyCount = _tableController.enemyCount(questDifficulty);
    questEnemyNumber = enemyCount;
    final (exp, gold) = _tableController.questReward(questDifficulty);
    questExp = exp;
    questGold = gold;
    enemyQuestName = (questDescription).toString();

    _updateEncounter("🏡", """
    $villageType
    เควส: กำจัด ${questDescription.toString()} $enemyCount ตัว
    ความยาก: ${_getQuestDifficulty(questDifficulty)}
    รางวัล: $exp EXP, $gold Gold
    """);

    _addLogEntry("🏡", "Village", "พบ $villageType และได้รับเควส: ");
  }

  void _generateNothingEvent() {
    _updateEncounter("⛅",
        "เส้นทางที่คุณเดินไม่มีแม้แต่เงา\nไม่มีสิ่งใดมารบกวนความสงบ\nความเป็นจริงที่แสนผ่อนคลาย");
    _addLogEntry(
        "🌟", "Peaceful", "You continue your journey without incident.");
  }

  void _generateEnemyEvent() {
    final index = TableController().getEnemyIndex(questNumber, questIsActive);
    final MonsterName enemy = _getRandomEnemy(index);
    final (enemyCoin, enemyDamage, enemyEXP) = _calculateEnemyStats(index);

    final battleDescription =
        _getBattleDescription(index, enemy, enemyDamage, enemyEXP, enemyCoin);
    _updateEncounter(enemy.emoji, battleDescription);
    _addLogEntry(
        "⚔️", "Battle", "Encountered a ${enemy.name}! $battleDescription");

    damageInput += (enemyDamage)
        .clamp(0, (_tableController.calculateCharacterHP - damageInput.value));
    print("damge before: ${damageInput.value} ");

    if (_tableController.healthReduceCondition(damageInput.value)) {
      if (questIsActive && enemyQuestName == enemy.toString()) {
        enemyQuestCounter.value++;
        if (enemyQuestCounter.value == questEnemyNumber) {
          expInput += questExp;
          coinInput += questGold;
          questReset();
        }
      }

      expInput += enemyEXP;
      coinInput += enemyCoin;
    } else {
      _handleCharacterDeath(enemy);
    }
  }

  void questReset() {
    questIsActive = false;
    questEnemyNumber = 0;
    questExp = 0;
    questGold = 0;
    questNumber = 0;
    enemyQuestCounter.value = 0;
  }

  void _handleCharacterDeath(MonsterName enemy) {
    mustSender.value = true;
    isDead.value = true;
    runBar.value = 0;
    spCounter.value = _tableController.calculateCharacterStamina;
    deathTimeRemaining.value = _tableController.timeTodie;
    final deathMessage = _getDeathMessage(enemy.toString());
    _updateEncounter("💀", deathMessage);
    _addLogEntry("💀", "Death", "Your character has fallen in battle.");

    _startReviveTimer();
  }

  void _generateRestEvent() {
    isResting.value = true;
    mustSender.value = true;
    runBar.value = 0;
    int healing = _tableController.restHealing;
    int restDurationShow = restDuration;
    damageInput.value -= (healing).clamp(0, damageInput.value);

    String selectedDialogue = _getRandomRestDialogue();

    _updateEncounter("🏕️",
        "$selectedDialogue\nฟื้นฟูพลังชีวิต $healing🔺\nพักผ่อนจากสนธยาจนรุ่งสาง");
    _addLogEntry("🏕️", "พัก",
        "$selectedDialogue\nHP $healing เวลา $restDurationShow วินาที");

    _restTimeRemaining.value = restDuration;
    _startRestTimer();
  }

  // Helper methods
  void _updateEncounter(String icon, String description) {
    _currentEncounterIcon.value = icon;
    _currentEncounterDescription.value = description;
  }

  void _addLogEntry(String icon, String title, String description) {
    _adventureLog.insert(
        0,
        LogEntry(
          icon: icon,
          title: title,
          description: description,
          timestamp: DateTime.now(),
        ));
  }

  double _getSpecialPercentage(int value) => value / 100;

  String _getRandomVillageType() {
    final villageTypes = [
      "🏘️ หมู่บ้านชาวนา",
      "🏠 หมู่บ้านชาวประมง",
      "🏚️ หมู่บ้านนักรบ",
      "🏰 หมู่บ้านพ่อมด",
      "🗻 หมู่บ้านกลางภูเขา"
    ];
    return villageTypes[Random().nextInt(villageTypes.length)];
  }

  MonsterName _getQuestDescription(int difficulty) {
    return enemy[difficulty][Random().nextInt(enemy[difficulty].length)];
  }

  MonsterName _getRandomEnemy(int index) {
    return enemy[index][Random().nextInt(enemy[index].length)];
  }

  String _getQuestDifficulty(int difficulty) {
    final questDifficulties = ["ง่าย", "ปานกลาง", "ท้าทาย", "เป็นไปไม่ได้"];
    return questDifficulties[difficulty];
  }

  (int, int, int) _calculateEnemyStats(int index) {
    int baseMax = (2 *
            (_characterController
                .calculateLevel(_characterController.currentExp))) +
        6;

    int baseMin =
        (_characterController.calculateLevel(_characterController.currentExp)) +
            3;
    final multipliers = [
      [2, 1, 1],
      [4, 2, 2],
      [8, 6, 5],
      [16, 13, 11]
    ];
    final baseValue = (Random().nextInt(baseMax).clamp(baseMin, baseMax)) *
        (_tableController.levelMultiplier).round();

    int coin = ((baseValue) * multipliers[index][1]).toInt();
    int damage = (baseValue * multipliers[index][2]).toInt();
    int exp = (((rollOne + 5).clamp(5, 20)) * multipliers[index][0]).toInt();

    return (
      _tableController.calculateCoin(coin, index),
      _tableController.calculateDamage(damage),
      _tableController.calculateEXP(exp)
    );
  }

  String _getBattleDescription(
      int index, MonsterName enemy, int damage, int exp, int coin) {
    final battleDescriptions = [
      [
        "${enemy.toString()} พุ่งดั่งสายฟ้า\nเลือดท่านกระเซ็น $damage🩸\nศัตรูแหลกลาญ $exp🧿 $coin💰",
        "${enemy.toString()} ตวัดกรงเล็บ\nกระดูกท่านสั่น $damage🩸\nศัตรูล้มครืน $exp🧿 $coin💰",
        "${enemy.toString()} โจมตีไร้ปรานี\nเนื้อท่านฉีก $damage🩸\nศัตรูขาดวิ่น $exp🧿 $coin💰",
        "${enemy.toString()} โผล่จากเงา\nเลือดท่านพุ่ง $damage🩸\nศัตรูยับเยิน $exp🧿 $coin💰",
        "${enemy.toString()} คำรามสนั่น\nแผลท่านแสบ $damage🩸\nศัตรูเป็นผุยผง $exp🧿 $coin💰"
      ],
      [
        "${enemy.toString()} โฉบดั่งพายุ\nเลือดท่านสาด $damage🩸\nศัตรูแหลกลาญ $exp🧿 $coin💰",
        "${enemy.toString()} รุมเร้าต่อเนื่อง\nร่างท่านระบม $damage🩸\nศัตรูขาดสะบั้น $exp🧿 $coin💰",
        "${enemy.toString()} ถีบทรงพลัง\nกระดูกท่านร้าว $damage🩸\nศัตรูล้มไม่ลุก $exp🧿 $coin💰",
        "${enemy.toString()} หมุนดั่งทอร์นาโด\nเนื้อท่านขาด $damage🩸\nศัตรูเป็นธุลี $exp🧿 $coin💰",
        "${enemy.toString()} ทะยานฟาดฟัน\nร่างท่านพรุน $damage🩸\nศัตรูไหม้เกรียม $exp🧿 $coin💰"
      ],
      [
        "${enemy.toString()} ปล่อยคลื่นทำลาย\nโลหิตท่านทะลัก $damage🩸\nศัตรูสิ้นซาก $exp🧿 $coin💰",
        "${enemy.toString()} พุ่งเหนือสายตา\nร่างท่านแหลก $damage🩸\nศัตรูหายวับ $exp🧿 $coin💰",
        "${enemy.toString()} ทะลุมิติโจมตี\nเนื้อท่านไหม้ $damage🩸\nศัตรูสูญในความว่าง $exp🧿 $coin💰",
        "${enemy.toString()} แผ่อำนาจล้นฟ้า\nตัวตนท่านสลาย $damage🩸\nศัตรูหายจากภพ $exp🧿 $coin💰",
        "${enemy.toString()} หยุดเวลาชั่วขณะ\nจิตท่านดับ $damage🩸\nศัตรูสิ้นทุกมิติ $exp🧿 $coin💰"
      ],
      [
        "${enemy.toString()} ปรากฏทั่วพร้อมกัน\nร่างท่านแตก $damage🩸\nศัตรูหายจากจริง $exp🧿 $coin💰",
        "${enemy.toString()} เป็นพลังบริสุทธิ์\nตัวท่านละลาย $damage🩸\nศัตรูพ้นสรรพสิ่ง $exp🧿 $coin💰",
        "${enemy.toString()} ทำลายกฎธรรมชาติ\nท่านหายจากกาล $damage🩸\nศัตรูดับทุกเป็นไปได้ $exp🧿 $coin💰",
        "${enemy.toString()} บิดเบือนความจริง\nท่านหายจากทรงจำ $damage🩸\nศัตรูสู่ไร้ตัวตน $exp🧿 $coin💰",
        "${enemy.toString()} ข้ามขอบตรรกะ\nท่านถูกลบจากอยู่ $damage🩸\nศัตรูสลายทุกมิติกาล $exp🧿 $coin💰"
      ]
    ];

    return battleDescriptions[index]
        [Random().nextInt(battleDescriptions[index].length)];
  }

  String _getDeathMessage(String enemy) {
    final deathMessages = [
      '${enemy.toString()} ยืนเหยียดยิ้ม\nเงาร่างสั่นไหว ความหวังริบหรี่',
      '${enemy.toString()} ปลิดชีพท่าน\nความเจ็บปวดแล่นผ่าน ชีวิตดับสูญ',
      '${enemy.toString()} ยืนมองชัยชนะ\nสนามรบเงียบงัน กลิ่นคาวคละคลุ้ง',
      '${enemy.toString()} หัวเราะก้อง\nเสียงสะท้อนในความมืด หัวใจหวาดหวั่น',
      '${enemy.toString()} ทอดเงายักษ์\nความกลัวครอบงำ โลกดูไร้หวัง',
      '${enemy.toString()} ยืนนิ่งดั่งรูปปั้น\nความหวาดกลัวแล่นปราด จิตใจสั่นคลอน',
      '${enemy.toString()} เดินเข้าใกล้\nหัวใจเต้นรัว ความตายใกล้เข้ามา',
      '${enemy.toString()} แผ่ซ่านไปทั่ว\nโลกรอบข้างพร่าเลือน ความหวังริบหรี่',
      '${enemy.toString()} ยืนตระหง่าน\nความมืดกลืนกินแสง ชีวิตใกล้ดับสูญ',
      '${enemy.toString()} ยิ้มเยาะ\nโลกทั้งใบมืดมิด ชีวิตสิ้นสุดลง'
    ];

    return deathMessages[Random().nextInt(deathMessages.length)];
  }

  String _getRandomRestDialogue() {
    List<String> restDialogues = [
      "โอเอซิสร่มรื่นกลางทะเลทราย",
      "ร่มเงาไม้ใหญ่ในป่าร้อน",
      "ถ้ำเย็นชื้นบนหน้าผาสูง",
      "ธารน้ำใสกลางป่าทึบ",
      "ลานหญ้าเขียวในทุ่งดอกไม้",
      "จุดชมวิวบนยอดเขาสูง",
      "ลำธารเย็นในหุบเขาลึก",
      "หาดทรายสงบใต้ดาวพราว",
      "บ้านร้างปลอดภัยท่ามพายุ",
      "ชายฝั่งสงบริมทะเลสาบกว้าง"
    ];

    return restDialogues[Random().nextInt(restDialogues.length)];
  }

  void _generateTreasureEvent() {
    final itemType = _tableController.randomItem();
    final (exp, coin) = _tableController.itemReward(itemType);

    final treasureType = _getRandomTreasureType(itemType);
    final description = _getDescriptiveTreasureEvent(treasureType, itemType);

    final rewardDescription = "ท่านได้พบ: $exp🧿 $coin💰";

    _updateEncounter("🎴", "$description\n$rewardDescription");
    _addLogEntry("🎴", "Treasure", "พบ $treasureType และได้รับรางวัล!");

    expInput += exp;
    coinInput += coin;
  }

  String _getRandomTreasureType(int itemType) {
    return items[itemType][Random().nextInt(items[itemType].length)].toString();
  }

  String _getDescriptiveTreasureEvent(String treasureType, int itemType) {
    final List<List<String>> descriptiveEvents = [
      [
        "ใบไม้พลิ้วไหวแสงริบหรี่\nเผยโฉม $treasureType ให้ได้มี",
        "เสียงโลหะดังใต้ฝ่าเท้า\nพบ $treasureType เฝ้ารอคอย",
        "กลิ่นกาลเวลาโชยมาไกล\nนำพา $treasureType ให้ได้ไขว่"
      ],
      [
        "เงาพิลึกบนผืนดิน\nใกล้เข้าไป $treasureType ถึงได้ยล",
        "เสียงกระซิบลึกลับนำ\nค้นพบ $treasureType ล้ำค่านัก",
        "แสงวาบวับเรียกสายตา\nเผย $treasureType น่าค้นหา"
      ],
      [
        "พลังโบราณสั่นสะเทือน\nนำทางสู่ $treasureType เลื่อนลือ",
        "ม่านพลังไหวสะท้าน\nเผย $treasureType ประจักษ์ตา",
        "เสียงบรรเลงแว่วไพเราะ\nพา $treasureType มาเสนอ"
      ],
      [
        "แสงสว่างจ้าฟ้าสะท้าน\n$treasureType ปรากฏกาล",
        "แผ่นดินแยกเปิดทางผ่าน\n$treasureType ตำนานปรากฏ",
        "เสียงกึกก้องโลกโบราณ\n$treasureType ผ่านกาลปรากฏ"
      ]
    ];

    return descriptiveEvents[itemType]
        [Random().nextInt(descriptiveEvents[itemType].length)];
  }

  @override
  void onClose() {
    WakelockPlus.disable();
    _stopTimers();
    super.onClose();
  }
}
