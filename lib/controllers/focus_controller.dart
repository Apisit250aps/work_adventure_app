import 'package:get/get.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/table_controller.dart';

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
  String toString() {
    return '$emoji $name';
  }
}

class FocusController extends GetxController {
  final CharacterController _characterController =
      Get.find<CharacterController>();
  final TableController _tableController = Get.find<TableController>();

  // Observable variables
  RxInt _timeRemaining = 3600.obs;
  final RxInt _totalTime = 3600.obs;
  final RxBool _isActive = false.obs;
  final RxList<LogEntry> _adventureLog = <LogEntry>[].obs;
  final RxString _currentEncounterIcon = "🌟".obs;
  final RxString _currentEncounterDescription =
      "Waiting for adventure...\n".obs;
  final RxInt eventCount = 0.obs;
  final RxBool _showingSummary = false.obs;
  RxInt spCounter = 0.obs;

  // Timers
  Timer? _timer;
  Timer? _eventTimer;
  Timer? _restTimer;
  Timer? _reviveTimer;

  // Getters
  int get timeRemaining => _timeRemaining.value;
  int get totalTime => _totalTime.value;
  bool get isActive => _isActive.value;
  List<LogEntry> get adventureLog => _adventureLog.toList();
  String get currentEncounterIcon => _currentEncounterIcon.value;
  String get currentEncounterDescription => _currentEncounterDescription.value;
  bool get showingSummary => _showingSummary.value;

  int get restDuration => _tableController.restTimer;

  // Other variables
  int rollOne = 0;

  // Quest variables
  String enemyQuestName = "";
  int enemyQuestCounter = 0;
  bool questIsActive = false;
  int questNumber = 21;
  int questGold = 0;
  int questExp = 0;
  int questEnemyNumber = 0;

  // Rest variables
  bool isRest = false;
  bool _isResting = false;

  int get _eventIntervalSeconds {
    if (_isResting) {
      return 0;
    }
    return _tableController.timeEventRun;
  }

  final RxInt _restTimeRemaining = 0.obs;

  final RxBool _isDead = false.obs;
  final RxInt _deathTimeRemaining = 0.obs;

  // Enemy data
  RxInt damageInput = 0.obs;
  RxInt expInput = 0.obs;
  RxInt coinInput = 0.obs;

  // สร้างตัวแปรสำหรับแต่ละสี
  final Color easyColor = Colors.green;
  final Color mediumColor = Colors.blue;
  final Color hardColor = Colors.purple;
  final Color impossibleColor = Colors.orange;

  late List<List<MonsterName>> enemy;

  @override
  void onInit() {
    super.onInit();
    enemy = [
      [
        MonsterName("🐺", "หมาป่าจิ๋ว", easyColor),
        MonsterName("🦇", "ค้างคาวราตรี", easyColor),
        MonsterName("🐗", "หมูป่าพิฆาต", easyColor),
        MonsterName("🦊", "จิ้งจอกไฟ", easyColor),
        MonsterName("🐍", "อสรพิษ", easyColor)
      ],
      [
        MonsterName("🧟", "ซอมบี้ราชา", mediumColor),
        MonsterName("💀", "โครงกระดูกอมตะ", mediumColor),
        MonsterName("🧛", "แวมไพร์เลือดเย็น", mediumColor),
        MonsterName("🐲", "มังกรไฟนรก", mediumColor),
        MonsterName("🧙", "พ่อมดมรณะ", mediumColor)
      ],
      [
        MonsterName("🐉", "มังกรทมิฬ", hardColor),
        MonsterName("💀", "ราชาลิชอนธการ", hardColor),
        MonsterName("🌑", "ปีศาจแห่งความมืด", hardColor),
        MonsterName("🧛🏻‍♂️", "เจ้าแวมไพร์ไร้พ่าย", hardColor),
        MonsterName("🧙🏻‍♂️", "จอมมารแห่งหายนะ", hardColor)
      ],
      [
        MonsterName("💀", "ราชันวิญญาณ", impossibleColor),
        MonsterName("⏳", "เทพแห่งกาลเวลา", impossibleColor),
        MonsterName("🗡️", "อัศวินแห่งความมืด", impossibleColor),
        MonsterName("🌙", "เทพจันทราและความฝัน", impossibleColor),
        MonsterName("🧙‍♂️", "จอมเวทแห่งอนันต์", impossibleColor)
      ]
    ];
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
      _startTimer();
      _startEventTimer();
    } else {
      _stopTimers();
    }
  }

  void resetFocus() {
    _stopTimers();
    _timeRemaining.value = _totalTime.value;
    _resetSessionState();
    _addLogEntry("🔄", "Reset", "Your adventure has been reset.");
  }

  void showSummary() {
    _showingSummary.value = true;
    _addLogEntry("🏁", "Summary", "Adventure completed!");
  }

  // Timer methods
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timeRemaining.value > 0) {
        _timeRemaining--;
      } else {
        _endSession();
      }
    });
  }

  void _startEventTimer() {
    _eventTimer?.cancel();
    _eventTimer = Timer.periodic(Duration(seconds: _eventIntervalSeconds), (_) {
      if (_isActive.value && _timeRemaining.value > 0) {
        _isResting = false;
        generateEvent();
      }
    });
  }

  void _startRestTimer() {
    _restTimer?.cancel();

    final totalStaminaToRecover = _tableController.calculateCharacterStamina;
    final staminaPerSecond = totalStaminaToRecover / restDuration;

    _restTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_restTimeRemaining.value > 0) {
        int restTime = restDuration + _eventIntervalSeconds + 1;
        _restTimeRemaining.value--;

        final elapsedTime = restTime - _restTimeRemaining.value;
        final recoveredStamina = (staminaPerSecond * elapsedTime).floor();

        spCounter.value = totalStaminaToRecover - (recoveredStamina ~/ 1.5);
      } else {
        spCounter.value = 0;
        _restTimer?.cancel();
        _startEventTimer(); // เริ่มตัวจับเวลาเหตุการณ์อีกครั้งหลังจากพัก
      }
    });
  }

  void _startReviveTimer() {
    _reviveTimer?.cancel();
    _reviveTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_restTimeRemaining.value > 0) {
        _deathTimeRemaining.value--;
      } else {
        _isDead.value = false;
        _reviveTimer?.cancel();
        _startEventTimer(); // เริ่มตัวจับเวลาเหตุการณ์อีกครั้งหลังจากพัก
      }
    });
  }

  void _stopTimers() {
    _timer?.cancel();
    _eventTimer?.cancel();
    _restTimer?.cancel();
  }

  void _endSession() {
    _stopTimers();
    _isActive.value = false;
    showSummary();
  }

  void _resetSessionState() {
    _isActive.value = false;
    _isResting = false;
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
    expInput.value = 0;
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
    double luckBonus =
        _getSpecialPercentage(_characterController.special.value.luck);
    int ranNumber = Random().nextInt(100) + 1;
    if (ranNumber <= (30 - luckBonus * 100).clamp(5, 30)) {
      _generateNothingEvent();
    } else if (ranNumber <= 95) {
      _generateEnemyEvent();
    } else if (!questIsActive) {
      _generateVillageEvent();
    } else {
      _generateEnemyEvent();
    }
  }

  void _generateVillageEvent() {
    questIsActive = true;
    final villageType = _getRandomVillageType();
    final questDifficulty = _tableController.selectQuest;
    questNumber = questDifficulty;
    final MonsterName questDescription = _getQuestDescription(questDifficulty);
    final enemyCount = _tableController.enemyCount(questDifficulty);
    enemyQuestCounter = enemyCount;
    final (exp, gold) = _tableController.questReward(questDifficulty);
    questExp = exp;
    questGold = gold;
    questEnemyNumber = enemyCount;

    _updateEncounter("🏡", """
    $villageType
    เควส: กำจัด ${questDescription.toString()} $enemyCount ตัว
    ความยาก: ${_getQuestDifficulty(questDifficulty)}
    รางวัล: $exp EXP, $gold Gold
    """);

    _addLogEntry("🏡", "Village", "พบ $villageType และได้รับเควส: ");
  }

  void _generateNothingEvent() {
    _updateEncounter("🌲",
        "คุณก้าวเท้าเดินไปบนเส้นทางอันเงียบสงบ\nไม่มีสิ่งใดมารบกวนการเดินทาง\nอันแสนผ่อนคลายของคุณ");
    _addLogEntry(
        "🌟", "Peaceful", "You continue your journey without incident.");
  }

  void _generateEnemyEvent() {
    rollOne = _tableController.singleDiceRoll();
    final index = TableController().getEnemyIndex(questNumber, questIsActive);
    final MonsterName enemy = _getRandomEnemy(index);
    final (enemyCoin, enemyDamage, enemyEXP) = _calculateEnemyStats(index);

    final battleDescription =
        _getBattleDescription(index, enemy, enemyDamage, enemyEXP, enemyCoin);
    _updateEncounter(enemy.emoji, battleDescription);
    _addLogEntry(
        "⚔️", "Battle", "Encountered a ${enemy.name}! $battleDescription");

    damageInput += enemyDamage;
    if (_tableController.healthReduceCondition(damageInput.value)) {
      expInput += enemyEXP;
      coinInput += enemyCoin;
    } else {
      _handleCharacterDeath(enemy);
    }
  }

  void _handleCharacterDeath(MonsterName enemy) {
    _isDead.value = true;
    _deathTimeRemaining.value = _tableController.timeTodie;
    final deathMessage = _getDeathMessage(enemy.toString());
    _updateEncounter("💀", "$deathMessage\n${_deathTimeRemaining.value}");
    _addLogEntry("💀", "Death", "Your character has fallen in battle.");

    _startReviveTimer();
  }

  String _getDeathMessage(String enemy) {
    final deathMessages = [
      "ดวงตาพร่าเลือน $enemy ยืนเหยียดยิ้ม",
      "เสียงกรีดร้อง $enemy ปลิดชีพท่าน",
      "โลหิตไหลริน $enemy ยืนมองชัยชนะ",
      "แสงริบหรี่ $enemy หัวเราะก้อง",
      "ความมืดโอบล้อม $enemy ทอดเงายักษ์"
    ];

    return deathMessages[Random().nextInt(deathMessages.length)];
  }

  void _generateRestEvent() {
    _isResting = true;
    int healing = _tableController.restHealing;
    int restDurationShow = restDuration + _eventIntervalSeconds + 1;
    damageInput.value -= (healing).clamp(0, damageInput.value);

    List<String> restDialogues = [
      "คุณพบโอเอซิสร่มรื่นท่ามกลางทะเลทราย",
      "คุณพบร่มเงาไม้ใหญ่ท่ามกลางป่าร้อน",
      "คุณพบถ้ำเย็นชื้นท่ามกลางหน้าผาสูง",
      "คุณพบธารน้ำใสท่ามกลางป่าทึบ",
      "คุณพบลานหญ้าเขียวขจีท่ามกลางทุ่งดอกไม้",
      "คุณพบจุดชมวิวท่ามกลางยอดเขาสูง",
      "คุณพบลำธารเย็นท่ามกลางหุบเขาลึก",
      "คุณพบหาดทรายสงบท่ามกลางคืนดาวพราว",
      "คุณพบบ้านร้างปลอดภัยท่ามกลางพายุ",
      "คุณพบชายฝั่งสงบท่ามกลางทะเลสาบกว้าง"
    ];

    String selectedDialogue =
        restDialogues[Random().nextInt(restDialogues.length)];

    _updateEncounter("🏕️",
        "$selectedDialogue\nฟื้นฟูพลังชีวิต $healing🔺\nพัก $restDurationShow วินาที");
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
    int baseMax = (_characterController.calculateLevel(0) ~/ 2) + 3;
    final multipliers = [
      [1, 1, 1],
      [2, 3, 3],
      [4, 6, 6],
      [8, 12, 10]
    ];
    final baseValue =
        (((rollOne).clamp(1, baseMax)) * _tableController.levelMultiplier)
            .floor();

    int coin = (baseValue * 10) * multipliers[index][1];
    int damage = baseValue * multipliers[index][2];
    int exp = ((rollOne + 10).clamp(10, 20)) * multipliers[index][0];

    return (
      _tableController.calculateCoin(coin, index),
      _tableController.calculateDamage(damage),
      _tableController.calculateEXP(exp)
    );
  }

  // ... (previous code remains the same)

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

  @override
  void onClose() {
    _stopTimers();
    super.onClose();
  }
}
