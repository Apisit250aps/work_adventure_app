import 'package:get/get.dart';
import 'dart:async';
import 'dart:math';
import 'package:work_adventure/controllers/character_controller.dart';

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

  int characterHP() {
    int baseHp = 100;
    int endurance = characterController.special.value.endurance;
    int characterHp = baseHp + (endurance * 10);
    return characterHp;
  }

  int characterStamina() {
    int baseStamina = 100;
    int strength = characterController.special.value.strength;
    int characterStamina = baseStamina + (strength * 10);
    return characterStamina;
  }

  int calculateEXP(int exp) {
    int intelligent = characterController.special.value.intelligence;
    int finalEXP = (exp + (exp * _getSpecialPercentage(intelligent))).round();
    return finalEXP;
  }

  int calculateCoin(int coin) {
    int perception = characterController.special.value.perception;
    int luck = characterController.special.value.luck;
    int finalCoin = (coin + ((coin * _getSpecialPercentage(luck)) * 5)).round();

    if (Random().nextInt(100) + (perception / 2) <= 49) {
      finalCoin = (finalCoin / 5).floor();
    }

    return finalCoin;
  }

  int calculateDamage(int damage, int strength) {
    // กำหนดค่าคงที่สำหรับการปรับแต่ง
    const double baseReduction = 0.1; // การลดดาเมจพื้นฐาน
    const double maxReduction = 0.90; // การลดดาเมจสูงสุด
    const double scalingFactor = 15; // ปัจจัยการปรับขนาด

    // คำนวณการลดดาเมจแบบ logarithmic
    double damageReductionPercentage = baseReduction +
        (log(strength + 1) / log(scalingFactor)) *
            (maxReduction - baseReduction);

    // จำกัดค่าการลดดาเมจให้อยู่ระหว่าง baseReduction และ maxReduction
    damageReductionPercentage =
        damageReductionPercentage.clamp(baseReduction, maxReduction);

    // คำนวณดาเมจสุดท้าย
    int finalDamage = (damage * (1 - damageReductionPercentage)).round();

    return finalDamage;
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
      } else {
        generateTreasureEvent();
      }
    }
  }

  void generateNothingEvent() {
    _currentEncounterIcon.value = "🌟";
    _currentEncounterDescription.value = "Nothing happened...\n";
    _addLogEntry(
        "🌟", "Peaceful", "You continue your journey without incident.");
  }

  // New method to calculate max health based on endurance
  int calculateMaxHealth() {
    int baseHealth = 100;
    double enduranceBonus =
        _getSpecialPercentage(characterController.special.value.endurance);
    return (baseHealth * (1 + enduranceBonus)).round();
  }

  void generateEnemyEvent() {
    List<String> enemies = [
      "👹 Ogre",
      "🐉 Dragon",
      "💀 Skeleton",
      "🧟‍♂️ Zombie",
      "🦇 Vampire",
      "🐺 Werewolf"
    ];
    String enemy = enemies[Random().nextInt(enemies.length)];

    double strengthBonus =
        _getSpecialPercentage(characterController.special.value.strength);
    double enduranceBonus =
        _getSpecialPercentage(characterController.special.value.endurance);

    int baseDamage = Random().nextInt(21) + 20;
    int damage = (baseDamage * (1 - enduranceBonus)).round().clamp(1, 50);

    int baseExp = Random().nextInt(21) + 10;
    int exp = (baseExp * (1 + strengthBonus)).round();

    int baseGold = Random().nextInt(15) + 5;
    int gold = (baseGold *
            (1 + _getSpecialPercentage(characterController.special.value.luck)))
        .round();

    _currentEncounterIcon.value = enemy.split(" ")[0];
    _currentEncounterDescription.value =
        "Battle with ${enemy.split(" ")[1]}! Took $damage damage. Gained $exp EXP and $gold Gold.";

    _addLogEntry("⚔️", "Battle",
        "Encountered a ${enemy.split(" ")[1]}! Took $damage damage. Gained $exp EXP and $gold Gold.");
  }

  void generateTreasureEvent() {
    List<String> treasures = [
      "💎 Gem",
      "🗡️ Sword",
      "🛡️ Shield",
      "📜 Scroll",
      "🔮 Magic Orb",
      "💍 Ring"
    ];
    String treasure = treasures[Random().nextInt(treasures.length)];

    double perceptionBonus =
        _getSpecialPercentage(characterController.special.value.perception);
    double luckBonus =
        _getSpecialPercentage(characterController.special.value.luck);

    int quantity =
        (Random().nextInt(3) + 1 + (perceptionBonus * 2)).round().clamp(1, 5);
    int baseGold = Random().nextInt(51) + 20;
    int gold = (baseGold * (1 + luckBonus)).round();

    _currentEncounterIcon.value = treasure.split(" ")[0];
    _currentEncounterDescription.value =
        "Found ${quantity}x ${treasure.split(" ")[1]}! Gained $gold Gold.\n";

    _addLogEntry("💎", "Treasure",
        "Found ${quantity}x ${treasure.split(" ")[1]}! Gained $gold Gold.");
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
