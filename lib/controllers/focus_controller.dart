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
  final CharacterController characterController =
      Get.find<CharacterController>();

  RxInt _timeRemaining = 0.obs;
  final RxInt _totalTime = 0.obs;
  final RxBool _isActive = false.obs;
  final RxList<LogEntry> _adventureLog = <LogEntry>[].obs;
  final RxString _currentEncounterIcon = "🌟".obs;
  final RxString _currentEncounterDescription =
      "Waiting for adventure...\n".obs;
  RxInt _eventCount = 0.obs;
  final RxBool _showingSummary = false.obs;

  Timer? _timer;
  Timer? _eventTimer;

  int get timeRemaining => _timeRemaining.value;
  int get totalTime => _totalTime.value;
  bool get isActive => _isActive.value;
  List<LogEntry> get adventureLog => _adventureLog.toList();
  String get currentEncounterIcon => _currentEncounterIcon.value;
  String get currentEncounterDescription => _currentEncounterDescription.value;
  bool get showingSummary => _showingSummary.value;
  int rollOne = TableController().singleDiceRoll();
  String enemyQuestName = "";
  int enemyQuestCounter = 0;

  // New method to get Special values as percentages
  double _getSpecialPercentage(int value) => value / 100;

  void initFocus(int minutes) {
    _totalTime.value = minutes * 60;
    _timeRemaining.value = _totalTime.value;
    _adventureLog.clear();
    _currentEncounterIcon.value = "🌟";
    _currentEncounterDescription.value = "Waiting for adventure...\n";
    _eventCount.value = 0;
    _showingSummary.value = false;
    _addLogEntry("🏁", "Adventure Start", "Your journey begins!");
  }

  void toggleActive() {
    _isActive.toggle();
    if (_isActive.value) {
      _startTimer();
      _startEventTimer();
    } else {
      _timer?.cancel();
      _eventTimer?.cancel();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_timeRemaining.value > 0) {
        _timeRemaining--;
      } else {
        _timer?.cancel();
        _eventTimer?.cancel();
        _isActive.value = false;
        showSummary();
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

  void resetFocus() {
    _timer?.cancel();
    _eventTimer?.cancel();
    _timeRemaining.value = _totalTime.value;
    _isActive.value = false;
    _adventureLog.clear();
    _currentEncounterIcon.value = "🌟";
    _currentEncounterDescription.value = "Waiting for adventure...\n";
    _eventCount.value = 0;
    _showingSummary.value = false;
    _addLogEntry("🔄", "Reset", "Your adventure has been reset.");
  }

  void generateEvent() {
    _eventCount++;
    if (_eventCount.value % 20 == 0) {
      generateRestEvent();
    } else {
      double luckBonus =
          _getSpecialPercentage(characterController.special.value.luck);
      int ranNumber = Random().nextInt(100) + 1;
      if (ranNumber <= (30 - luckBonus * 100).clamp(5, 30)) {
        generateNothingEvent();
      } else if (ranNumber <= 95) {
        generateEnemyEvent();
      }
    }
  }

  void generateVillageEvent() {
    final villageTypes = [
      "🏘️ หมู่บ้านชาวนา",
      "🏠 หมู่บ้านชาวประมง",
      "🏚️ หมู่บ้านนักรบ",
      "🏰 หมู่บ้านพ่อมด",
      "🗻 หมู่บ้านกลางภูเขา"
    ];

    final enemyQuest = [
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

    final questDifficulties = ["ง่าย", "ปานกลาง", "ท้าทาย", "เป็นไปไม่ได้"];

    final villageType = villageTypes[Random().nextInt(villageTypes.length)];
    final questDifficulty = TableController().selectQuest();

    String questDescription = enemyQuest[questDifficulty]
        [Random().nextInt(enemyQuest[questDifficulty].length)];

    int enemyCount = TableController().enemyCount(questDifficulty);
    enemyQuestCounter = enemyCount;

    var (exp, gold) = TableController().questReward(questDifficulty);

    _currentEncounterIcon.value = "🏡";
    _currentEncounterDescription.value = """
    $villageType
    เควส: กำจัด $questDescription $enemyCount ตัว
    ความยาก: ${questDifficulties[questDifficulty]}
    รางวัล: $exp EXP, $gold ทองคำ

    """;

    _addLogEntry("🏡", "Village", "พบ $villageType และได้รับเควส: ");
  }

  void generateNothingEvent() {
    _currentEncounterIcon.value = "🌟";
    _currentEncounterDescription.value = "Nothing happened...\n";
    _addLogEntry(
        "🌟", "Peaceful", "You continue your journey without incident.");
  }

  void generateEnemyEvent() {
    final enemyTypes = [
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

    final index = rollOne >= 13
        ? 0
        : rollOne >= 7
            ? 1
            : rollOne >= 2
                ? 2
                : 3;
    final multipliers = [
      [1, 1, 1], // EXP, Coin, Damage for Common
      [2, 3, 3], // for Uncommon
      [4, 6, 6], // for Rare
      [8, 12, 10] // for God
    ];

    final baseValue = (rollOne + 5).clamp(5, 15);

    int coin = baseValue * multipliers[index][1];
    int damage = baseValue * multipliers[index][2];
    int exp = ((rollOne + 10).clamp(10, 20)) * multipliers[index][0];

    final enemyCoin = TableController().calculateCoin(coin, index);
    final enemyDamage = TableController().calculateDamage(damage);
    final enemyEXP = TableController().calculateEXP(exp);

    final enemy = enemyTypes[index][Random().nextInt(enemyTypes[index].length)];
    final parts = enemy.split(" ");
    _currentEncounterIcon.value = parts[0];
    final enemyName = parts.sublist(1).join(" ");

    final List<List<String>> battleDescriptionsByLevel = [
      // Common (index 0)
      [
        "ต่อกร $enemyName! ⚔️ เสียเลือด $enemyDamage ชัยชนะเป็นของท่าน ✨ ได้ $enemyEXP EXP $enemyCoin ทองคำ",
        "ดาบปะทะ $enemyName 🗡️ บาดแผล $enemyDamage ท่านเอาชนะได้ 💪 รับ $enemyEXP EXP $enemyCoin เหรียญ",
        "$enemyName โจมตี! 💥 เสียหาย $enemyDamage ท่านผ่านด่านนี้ไปได้ 🛡️ คว้า $enemyEXP EXP $enemyCoin ทอง",
        "ศึก $enemyName! 🏹 โดนโจมตี $enemyDamage ท่านเอาชนะได้ 🎉 ได้รับ $enemyEXP EXP $enemyCoin ทองคำ",
        "ปะทะ $enemyName 🔪 เสียเลือด $enemyDamage ท่านคว้าชัยชนะ 🏆 รับ $enemyEXP EXP $enemyCoin เหรียญทอง"
      ],
      // Uncommon (index 1)
      [
        "ดวลดาบ $enemyName! ⚔️ บาดเจ็บ $enemyDamage ท่านเอาชนะได้ 💪 คว้า $enemyEXP EXP $enemyCoin ทองคำ",
        "$enemyName โหมโจมตี! 🌪️ เสียเลือด $enemyDamage ท่านต้านทานได้ 🛡️ รับ $enemyEXP EXP $enemyCoin เหรียญ",
        "ศึกเดือด $enemyName! 🔥 โดนถล่ม $enemyDamage ท่านชนะในที่สุด ✨ ได้ $enemyEXP EXP $enemyCoin ทอง",
        "ต่อสู้ $enemyName! 💢 บาดแผลลึก $enemyDamage ท่านเอาชนะได้ 🎊 คว้า $enemyEXP EXP $enemyCoin ทองคำ",
        "ปะทะดุ $enemyName 💀 เสียหาย $enemyDamage ท่านผ่านด่านมาได้ 🌟 รับ $enemyEXP EXP $enemyCoin เหรียญทอง"
      ],
      // Rare (index 2)
      [
        "ศึกใหญ่ $enemyName! 🐉 เลือดท่วม $enemyDamage ท่านเอาชนะได้ 🏅 คว้า $enemyEXP EXP $enemyCoin ทองคำ",
        "$enemyName อสูรร้าย! 👹 บาดเจ็บสาหัส $enemyDamage ท่านไม่ยอมแพ้ 💪🔥 ได้ $enemyEXP EXP $enemyCoin ทอง",
        "ดวลเดือด $enemyName! ⚡ เกือบสิ้นใจ $enemyDamage ท่านลุกขึ้นสู้ �Phoenix รับ $enemyEXP EXP $enemyCoin เหรียญ",
        "ต่อกร $enemyName ผู้ทรงพลัง! 💥 โดนถล่ม $enemyDamage ท่านชนะได้ 🎇 คว้า $enemyEXP EXP $enemyCoin ทองคำ",
        "ศึกมหากาพย์ $enemyName! 🌋 สาหัส $enemyDamage ท่านพลิกสถานการณ์ 🌠 ได้ $enemyEXP EXP $enemyCoin ทอง"
      ],
      // God (index 3)
      [
        "ท้าชนเทพ $enemyName! 🌟 เกือบพ่ายแพ้ $enemyDamage ท่านชนะอย่างเหลือเชื่อ 🏆🌈 ได้ $enemyEXP EXP $enemyCoin ทองคำ",
        "ศึกแห่งตำนาน $enemyName! 🔱 บาดเจ็บสาหัส $enemyDamage ท่านเอาชนะได้ 🌠💫 คว้า $enemyEXP EXP $enemyCoin ทอง",
        "ปะทะ $enemyName เทพเจ้า! ⚡🌩️ โดนถล่ม $enemyDamage ท่านพลิกโผชนะ 🌈🏅 รับ $enemyEXP EXP $enemyCoin เหรียญทอง",
        "ดวลเทพ $enemyName! 🌞 เลือดท่วมกาย $enemyDamage ท่านก้าวข้ามขีดจำกัด 🚀💥 ได้ $enemyEXP EXP $enemyCoin ทองคำ",
        "$enemyName มหาเทพ! 🌌 เกือบสิ้นชีพ $enemyDamage ท่านชนะอย่างอัศจรรย์ 🎇✨ คว้า $enemyEXP EXP $enemyCoin ทอง"
      ]
    ];

// ใช้งานในฟังก์ชัน generateEnemyEvent
    final battleDescription = battleDescriptionsByLevel[index]
        [Random().nextInt(battleDescriptionsByLevel[index].length)];
    _currentEncounterDescription.value = battleDescription;
    _addLogEntry(
        "⚔️", "Battle", "Encountered a $enemyName! $battleDescription");
  }

  void generateRestEvent() {
    double intelligenceBonus =
        _getSpecialPercentage(characterController.special.value.intelligence);
    int healing = (Random().nextInt(31) + 20 * (1 + intelligenceBonus)).round();

    _currentEncounterIcon.value = "🏕️";
    _currentEncounterDescription.value =
        "Found a safe spot to rest. Healed $healing HP.\n";

    _addLogEntry(
        "🏕️", "Rest", "Found a safe spot to rest. Healed $healing HP.");
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

  void showSummary() {
    _showingSummary.value = true;
    _addLogEntry("🏁", "Summary", "Adventure completed!");
  }

  @override
  void onClose() {
    _timer?.cancel();
    _eventTimer?.cancel();
    super.onClose();
  }
}
