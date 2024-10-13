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
  RxInt _eventCount = 0.obs;
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
  String enemyQuestName = "";
  int enemyQuestCounter = 0;
  bool questIsActive = false;
  int questNumber = 21;
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
      "🧙🏻‍♂️ จอมมารแห่งความหายนะ"
    ],
    [
      "💀 มอร์ติส เรกซ์ ราชาแห่งวิญญาณ",
      "⏳ คโรโนส เทพแห่งกาลเวลาที่หยุดนิ่ง",
      "🗡️ เซอร์กริมบาลด์ อัศวินแห่งความมืด",
      "🌙 ลูนาเรีย เทพธิดาแห่งจันทราและความฝัน",
      "🧙‍♂️ อาซาเซล จอมเวทแห่งความรู้อนันต์"
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
  void toggleActive() {
    _isActive.toggle();
    if (_isActive.value) {
      _startTimer();
      _startEventTimer();
    } else {
      _stopTimers();
    }
  }

  // Reset focus session
  void resetFocus() {
    _stopTimers();
    _timeRemaining.value = _totalTime.value;
    _resetSessionState();
    _addLogEntry("🔄", "Reset", "Your adventure has been reset.");
  }

  // Generate events
  void generateEvent() {
    _eventCount++;
    if (_eventCount.value % 20 == 0) {
      _generateRestEvent();
    } else {
      _generateRandomEvent();
    }
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

  void _startEventTimer() {
    _eventTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_isActive.value && _timeRemaining.value > 0) {
        generateEvent();
      }
    });
  }

  void _stopTimers() {
    _timer?.cancel();
    _eventTimer?.cancel();
  }

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
    _eventCount.value = 0;
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
    } else {
      _generateVillageEvent();
    }
  }

  void _generateVillageEvent() {
    final villageType = _getRandomVillageType();
    final questDifficulty = _tableController.selectQuest();
    final questDescription = _getQuestDescription(questDifficulty);
    final enemyCount = _tableController.enemyCount(questDifficulty);
    enemyQuestCounter = enemyCount;
    final (exp, gold) = _tableController.questReward(questDifficulty);

    _updateEncounter("🏡", """
    $villageType
    เควส: กำจัด $questDescription $enemyCount ตัว
    ความยาก: ${_getQuestDifficulty(questDifficulty)}
    รางวัล: $exp EXP, $gold Gold
    """);

    _addLogEntry("🏡", "Village", "พบ $villageType และได้รับเควส: ");
  }

  void _generateNothingEvent() {
    _updateEncounter("🌟", "Nothing happened...\n");
    _addLogEntry(
        "🌟", "Peaceful", "You continue your journey without incident.");
  }

  void _generateEnemyEvent() {
    rollOne = _tableController.singleDiceRoll();
    final index = _getEnemyIndex(rollOne);
    final enemy = _getRandomEnemy(index);
    final (enemyCoin, enemyDamage, enemyEXP) = _calculateEnemyStats(index);

    final battleDescription =
        _getBattleDescription(index, enemy, enemyDamage, enemyEXP, enemyCoin);
    _updateEncounter(enemy.split(" ")[0], battleDescription);
    _addLogEntry("⚔️", "Battle",
        "Encountered a ${enemy.split(" ").sublist(1).join(" ")}! $battleDescription");
  }

  void _generateRestEvent() {
    double intelligenceBonus =
        _getSpecialPercentage(_characterController.special.value.intelligence);
    int healing = (Random().nextInt(31) + 20 * (1 + intelligenceBonus)).round();

    _updateEncounter("🏕️", "Found a safe spot to rest. Healed $healing HP.\n");
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
        "ต่อกร $enemy! ⚔️ เสียเลือด $damage ชัยชนะเป็นของท่าน ✨ ได้ $exp EXP $coin ทองคำ",
        "ดาบปะทะ $enemy 🗡️ บาดแผล $damage ท่านเอาชนะได้ 💪 รับ $exp EXP $coin เหรียญ"
      ],
      [
        "ดวลดาบ $enemy! ⚔️ บาดเจ็บ $damage ท่านเอาชนะได้ 💪 คว้า $exp EXP $coin ทองคำ",
        "$enemy โหมโจมตี! 🌪️ เสียเลือด $damage ท่านต้านทานได้ 🛡️ รับ $exp EXP $coin เหรียญ"
      ],
      [
        "ศึกใหญ่ $enemy! 🐉 เลือดท่วม $damage ท่านเอาชนะได้ 🏅 คว้า $exp EXP $coin ทองคำ",
        "$enemy อสูรร้าย! 👹 บาดเจ็บสาหัส $damage ท่านไม่ยอมแพ้ 💪🔥 ได้ $exp EXP $coin ทอง"
      ],
      [
        "ท้าชนเทพ $enemy! 🌟 เกือบพ่ายแพ้ $damage ท่านชนะอย่างเหลือเชื่อ 🏆🌈 ได้ $exp EXP $coin ทองคำ",
        "ศึกแห่งตำนาน $enemy! 🔱 บาดเจ็บสาหัส $damage ท่านเอาชนะได้ 🌠💫 คว้า $exp EXP $coin ทอง"
      ],
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
