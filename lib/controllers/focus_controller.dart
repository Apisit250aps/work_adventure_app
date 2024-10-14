import 'package:get/get.dart';
import 'dart:async';
import 'dart:math';
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

class FocusController extends GetxController {
  final CharacterController _characterController =
      Get.find<CharacterController>();
  final TableController _tableController = TableController();

  // Observable variables
  RxInt _timeRemaining = 0.obs;
  final RxInt _totalTime = 0.obs;
  final RxBool _isActive = false.obs;
  final RxList<LogEntry> _adventureLog = <LogEntry>[].obs;
  final RxString _currentEncounterIcon = "🌟".obs;
  final RxString _currentEncounterDescription =
      "Waiting for adventure...\n".obs;
  RxInt eventCount = 0.obs;
  final RxBool _showingSummary = false.obs;

  // Timers
  Timer? _timer;
  Timer? _eventTimer;

  // Getters
  int get timeRemaining => _timeRemaining.value;
  int get totalTime => _totalTime.value;
  bool get isActive => _isActive.value;
  List<LogEntry> get adventureLog => _adventureLog.toList();
  String get currentEncounterIcon => _currentEncounterIcon.value;
  String get currentEncounterDescription => _currentEncounterDescription.value;
  bool get showingSummary => _showingSummary.value;

  // Other variables
  int rollOne = 0;

  // Quest
  String enemyQuestName = "";
  int enemyQuestCounter = 0;
  bool questIsActive = false;
  int questNumber = 21;
  int questGold = 0;
  int questExp = 0;
  int questEnemyNumber = 0;

  final enemy = [
    [
      "🐺 หมาป่าจิ๋ว",
      "🦇 ค้างคาวราตรี",
      "🐗 หมูป่าพิฆาต",
      "🦊 จิ้งจอกไฟ",
      "🐍 อสรพิษ"
    ],
    [
      "🧟 ซอมบี้ราชา",
      "💀 โครงกระดูกอมตะ",
      "🧛 แวมไพร์เลือดเย็น",
      "🐲 มังกรไฟนรก",
      "🧙 พ่อมดมรณะ"
    ],
    [
      "🐉 มังกรทมิฬ",
      "💀 ราชาลิชอนธการ",
      "🌑 ปีศาจแห่งความมืด",
      "🧛🏻‍♂️ เจ้าแวมไพร์ไร้พ่าย",
      "🧙🏻‍♂️ จอมมารแห่งหายนะ"
    ],
    [
      "💀 ราชันวิญญาณ",
      "⏳ เทพแห่งกาลเวลา",
      "🗡️ อัศวินแห่งความมืด",
      "🌙 เทพจันทราและความฝัน",
      "🧙‍♂️ จอมเวทแห่งอนันต์"
    ]
  ];

  // Initialize focus session
  void initFocus(int minutes) {
    _totalTime.value = minutes * 60;
    _timeRemaining.value = _totalTime.value;
    _resetSessionState();
    _addLogEntry("🏁", "Adventure Start", "Your journey begins!");
  }

  // Toggle active state
  @override
  void onInit() {
    super.onInit();
    _eventIntervalSeconds = _tableController.timeEventRun();
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

  void _startEventTimer() {
    // Cancel existing timer if any
    _eventTimer?.cancel();

    _eventTimer = Timer.periodic(Duration(seconds: _eventIntervalSeconds), (_) {
      if (_isActive.value && _timeRemaining.value > 0) {
        generateEvent();
      }
    });
  }

  void _stopTimers() {
    _timer?.cancel();
    _eventTimer?.cancel();
  }

  // Keep generateEvent() as is
  void generateEvent() {
    eventCount++;

    if (_tableController.timeToRest(eventCount.toInt())) {
      _generateRestEvent();
    } else {
      _generateRandomEvent();
    }
  }

  // Reset focus session
  void resetFocus() {
    _stopTimers();
    _timeRemaining.value = _totalTime.value;
    _resetSessionState();
    _addLogEntry("🔄", "Reset", "Your adventure has been reset.");
  }

  // Show summary
  void showSummary() {
    _showingSummary.value = true;
    _addLogEntry("🏁", "Summary", "Adventure completed!");
  }

  // Private methods
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timeRemaining.value > 0) {
        _timeRemaining--;
      } else {
        _endSession();
      }
    });
  }

  late final int _eventIntervalSeconds;

  void _endSession() {
    _stopTimers();
    _isActive.value = false;
    showSummary();
  }

  void _resetSessionState() {
    _isActive.value = false;
    _adventureLog.clear();
    _currentEncounterIcon.value = "🌟";
    _currentEncounterDescription.value = "Waiting for adventure...\n";
    eventCount.value = 0;
    _showingSummary.value = false;
  }

  void _generateRandomEvent() {
    double luckBonus =
        _getSpecialPercentage(_characterController.special.value.luck);
    int ranNumber = Random().nextInt(100) + 1;
    if (ranNumber <= (30 - luckBonus * 100).clamp(5, 30)) {
      _generateNothingEvent();
    } else if (ranNumber <= 95) {
      _generateEnemyEvent();
    } else if (questIsActive == false) {
      _generateVillageEvent();
    } else {
      _generateEnemyEvent();
    }
  }

  void _generateVillageEvent() {
    questIsActive = true;
    final villageType = _getRandomVillageType();
    final questDifficulty = _tableController.selectQuest();
    questNumber = questDifficulty;
    final questDescription = _getQuestDescription(questDifficulty);
    final enemyCount = _tableController.enemyCount(questDifficulty);
    enemyQuestCounter = enemyCount;
    final (exp, gold) = _tableController.questReward(questDifficulty);
    questExp = exp;
    questGold = gold;
    questEnemyNumber = enemyCount;

    _updateEncounter("🏡", """
    $villageType
    เควส: กำจัด $questDescription $enemyCount ตัว
    ความยาก: ${_getQuestDifficulty(questDifficulty)}
    รางวัล: $exp EXP, $gold Gold
    """);

    _addLogEntry("🏡", "Village", "พบ $villageType และได้รับเควส: ");
  }

  void _generateNothingEvent() {
    _updateEncounter("🌲🌲🌲",
        "คุณก้าวเท้าเดินไปบนเส้นทางอันเงียบสงบไม่มีสิ่งใดมารบกวนการเดินทางอันแสนผ่อนคลายของคุณ");
    _addLogEntry(
        "🌟", "Peaceful", "You continue your journey without incident.");
  }

  void _generateEnemyEvent() {
    rollOne = _tableController.singleDiceRoll();
    final index = TableController().getEnemyIndex(questNumber, questIsActive);
    final enemy = _getRandomEnemy(index);
    final (enemyCoin, enemyDamage, enemyEXP) = _calculateEnemyStats(index);

    final battleDescription =
        _getBattleDescription(index, enemy, enemyDamage, enemyEXP, enemyCoin);
    _updateEncounter(enemy.split(" ")[0], battleDescription);
    _addLogEntry("⚔️", "Battle",
        "Encountered a ${enemy.split(" ").sublist(1).join(" ")}! $battleDescription");
  }

  void questSlayer(
    String name,
  ) {
    if (name == enemyQuestName) {
      enemyQuestCounter += 1;
    }

    if (enemyQuestCounter == questEnemyNumber) {}
  }

  void _generateRestEvent() {
    double intelligenceBonus =
        _getSpecialPercentage(_characterController.special.value.intelligence);
    int healing = (Random().nextInt(31) + 20 * (1 + intelligenceBonus)).round();

    _updateEncounter("🏕️",
        "คุณพบจุดพักที่ปลอดภัยท่ามกลางธรรมชาติ\nพลังชีวิตของคุณเพิ่มขึ้น $healing หน่วย");
    _addLogEntry(
        "🏕️", "Rest", "Found a safe spot to rest. Healed $healing HP.");
  }

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

  // Helper methods
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

  String _getQuestDescription(int difficulty) {
    return enemy[difficulty][Random().nextInt(enemy[difficulty].length)];
  }

  String _getQuestDifficulty(int difficulty) {
    final questDifficulties = ["ง่าย", "ปานกลาง", "ท้าทาย", "เป็นไปไม่ได้"];
    return questDifficulties[difficulty];
  }

  String _getRandomEnemy(int index) {
    return enemy[index][Random().nextInt(enemy[index].length)];
  }

  (int, int, int) _calculateEnemyStats(int index) {
    final multipliers = [
      [1, 1, 1],
      [2, 3, 3],
      [4, 6, 6],
      [8, 12, 10]
    ];
    final baseValue = (rollOne + 5).clamp(5, 15);

    int coin = baseValue * multipliers[index][1];
    int damage = baseValue * multipliers[index][2];
    int exp = ((rollOne + 10).clamp(10, 20)) * multipliers[index][0];

    return (
      _tableController.calculateCoin(coin, index),
      _tableController.calculateDamage(damage),
      _tableController.calculateEXP(exp)
    );
  }

  String _getBattleDescription(
      int index, String enemy, int damage, int exp, int coin) {
    final battleDescriptions = [
      [
        "$enemy\nเลือดท่านกระเซ็น $damage\nบดขยี้ศัตรูราบคาบ $exp 🧿 $coin 💰",
        "$enemy\nกระดูกท่านสั่น $damage\nหักเขี้ยวเล็บศัตรูสิ้น $exp 🧿 $coin 💰",
        "$enemy\nเนื้อท่านฉีก $damage\nเชือดเฉือนศัตรูขาดวิ่น $exp 🧿 $coin 💰",
        "$enemy\nเลือดท่านพุ่ง $damage\nเหยียบศัตรูย่อยยับ $exp 🧿 $coin 💰",
        "$enemy\nแผลท่านแดงฉาน $damage\nบดศัตรูเป็นจุณ $exp 🧿 $coin 💰"
      ],
      [
        "$enemy\nเลือดท่านสาด $damage\nฉีกศัตรูเป็นชิ้นๆ $exp 🧿 $coin 💰",
        "$enemy\nร่างท่านระบม $damage\nบั่นคอศัตรูขาดกระเด็น $exp 🧿 $coin 💰",
        "$enemy\nกระดูกท่านร้าว $damage\nทิ้งศัตรูเป็นซากศพ $exp 🧿 $coin 💰",
        "$enemy\nเนื้อท่านแหลก $damage\nสังหารศัตรูไม่เหลือซาก $exp 🧿 $coin 💰",
        "$enemy\nร่างท่านพรุน $damage\nเผาศัตรูเป็นจุณ $exp 🧿 $coin 💰"
      ],
      [
        "$enemy\nโลหิตท่านทะลัก $damage\nทำลายล้างศัตรูสิ้นซาก $exp 🧿 $coin 💰",
        "$enemy\nร่างท่านแหลกลาญ $damage\nลบศัตรูออกจากความทรงจำ $exp 🧿 $coin 💰",
        "$enemy\nเนื้อท่านไหม้เกรียม $damage\nบดขยี้ศัตรูสู่ความว่างเปล่า $exp 🧿 $coin 💰",
        "$enemy\nตัวตนท่านสลาย $damage\nลบศัตรูออกจากทุกภพภูมิ $exp 🧿 $coin 💰",
        "$enemy\nจิตท่านดับสูญ $damage\nทำลายล้างศัตรูจากทุกมิติ $exp 🧿 $coin 💰"
      ],
      [
        "$enemy\nร่างท่านแตกดับ $damage\nล้างศัตรูออกจากความจริง $exp 🧿 $coin 💰",
        "$enemy\nตัวตนท่านสูญสิ้น $damage\nกวาดศัตรูพ้นสรรพสิ่ง $exp 🧿 $coin 💰",
        "$enemy\nท่านถูกลบจากกาลเวลา $damage\nผลาญศัตรูจากความเป็นไปได้ $exp 🧿 $coin 💰",
        "$enemy\nท่านหายไปจากความทรงจำ $damage\nบดศัตรูสู่ความไม่มีตัวตน $exp 🧿 $coin 💰",
        "$enemy\nท่านถูกลบจากความเป็นจริง $damage\nลบศัตรูออกจากการดำรงอยู่ $exp 🧿 $coin 💰"
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
