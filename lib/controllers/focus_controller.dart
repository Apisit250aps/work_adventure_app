import 'package:get/get.dart';
import 'dart:async';
import 'dart:math';

class FocusController extends GetxController {
  RxInt _timeRemaining = 0.obs;
  final RxInt _totalTime = 0.obs;
  final RxBool _isActive = false.obs;
  final RxMap<String, int> _inventory = <String, int>{}.obs;
  final RxList<Event> _events = <Event>[].obs;
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
  Map<String, int> get inventory => _inventory;
  List<Event> get events => _events;
  String get currentEncounterIcon => _currentEncounterIcon.value;
  String get currentEncounterDescription => _currentEncounterDescription.value;
  bool get showingSummary => _showingSummary.value;

  void initFocus(int minutes) {
    _totalTime.value = minutes * 60;
    _timeRemaining.value = _totalTime.value;
    _inventory.clear();
    _events.clear();
    _currentEncounterIcon.value = "🌟";
    _currentEncounterDescription.value = "Waiting for adventure...\n";
    _eventCount.value = 0;
    _showingSummary.value = false;
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
    _inventory.clear();
    _events.clear();
    _currentEncounterIcon.value = "🌟";
    _currentEncounterDescription.value = "Waiting for adventure...\n";
    _eventCount.value = 0;
    _showingSummary.value = false;
  }

  void generateEvent() {
    _eventCount++;
    if (_eventCount.value % 20 == 0) {
      generateRestEvent();
    } else {
      int ranNumber = Random().nextInt(100) + 1;
      if (ranNumber <= 40) {
        generateNothingEvent();
      } else if (ranNumber <= 90) {
        generateEnemyEvent();
      } else {
        generateTreasureEvent();
      }
    }
  }

  void generateNothingEvent() {
    _currentEncounterIcon.value = "🌟";
    _currentEncounterDescription.value = "Nothing happened...\n";
    _events.insert(
        0,
        Event(
            icon: "🌟",
            title: "Peaceful",
            description: "You continue your journey without incident."));
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
    int damage = Random().nextInt(16) + 15;
    int exp = Random().nextInt(16) + 5;
    int gold = Random().nextInt(10) + 1;

    _currentEncounterIcon.value = enemy.split(" ")[0];
    _currentEncounterDescription.value =
        "Battle with ${enemy.split(" ")[1]}! Took $damage damage. Gained $exp EXP and $gold Gold.";

    addToInventory("💰 Gold", gold);
    addToInventory("⚔️ EXP", exp);

    _events.insert(
        0,
        Event(
            icon: "⚔️",
            title: "Battle",
            description:
                "Encountered a ${enemy.split(" ")[1]}! Took $damage damage. Gained $exp EXP and $gold Gold."));
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
    int quantity = Random().nextInt(3) + 1;
    int gold = Random().nextInt(41) + 10;

    _currentEncounterIcon.value = treasure.split(" ")[0];
    _currentEncounterDescription.value =
        "Found ${quantity}x ${treasure.split(" ")[1]}! Gained $gold Gold.\n";

    addToInventory(treasure, quantity);
    addToInventory("💰 Gold", gold);

    _events.insert(
        0,
        Event(
            icon: "💎",
            title: "Treasure",
            description:
                "Found ${quantity}x ${treasure.split(" ")[1]}! Gained $gold Gold.\n"));
  }

  void generateRestEvent() {
    int healing = Random().nextInt(31) + 20;
    _currentEncounterIcon.value = "🏕️";
    _currentEncounterDescription.value =
        "Found a safe spot to rest. Healed $healing HP.\n";

    addToInventory("❤️ HP", healing);

    _events.insert(
        0,
        Event(
            icon: "🏕️",
            title: "Rest",
            description: "Found a safe spot to rest. Healed $healing HP.\n"));
  }

  void addToInventory(String item, int quantity) {
    if (_inventory.containsKey(item)) {
      _inventory[item] = _inventory[item]! + quantity;
    } else {
      _inventory[item] = quantity;
    }
  }

  void showSummary() {
    _showingSummary.value = true;
    _events.insert(
        0,
        Event(
            icon: "🏁",
            title: "Summary",
            description: "Adventure completed!\n"));
  }

  @override
  void onClose() {
    _timer?.cancel();
    _eventTimer?.cancel();
    super.onClose();
  }
}

class Event {
  final String icon;
  final String title;
  final String description;

  Event({required this.icon, required this.title, required this.description});
}
