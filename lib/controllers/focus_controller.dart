import 'package:get/get.dart';
import 'dart:async';
import 'dart:math';

class FocusController extends GetxController {
  final RxMap<String, int> _inventory = <String, int>{}.obs;
  RxInt _timeRemaining = 0.obs;
  final RxInt _totalTime = 0.obs;
  final RxBool _isActive = false.obs;
  final RxList<Event> _events = <Event>[].obs;
  final RxString _currentEncounterIcon = "🌟".obs;
  final RxString _currentEncounterDescription =
      "Waiting for adventure...\n".obs;
  RxInt _eventCount = 0.obs;
  final RxBool _showingSummary = false.obs;

  Map<String, int> get inventory => _inventory;
  int get timeRemaining => _timeRemaining.value;
  int get totalTime => _totalTime.value;
  bool get isActive => _isActive.value;
  List<Event> get events => _events;
  String get currentEncounterIcon => _currentEncounterIcon.value;
  String get currentEncounterDescription => _currentEncounterDescription.value;
  bool get showingSummary => _showingSummary.value;

  late Timer _timer;
  late Timer _eventTimer;

  void initFocus(int focusTimeMinutes) {
    _timeRemaining.value = focusTimeMinutes * 60;
    _totalTime.value = focusTimeMinutes * 60;
    _isActive.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateTimer());
    _eventTimer =
        Timer.periodic(const Duration(seconds: 3), (_) => _generateEvent());
  }

  void setFocusTime(int minutes) {
    _totalTime.value = minutes * 60;
    _timeRemaining.value = _totalTime.value;
  }

  void _updateTimer() {
    if (_isActive.value && _timeRemaining.value > 0) {
      _timeRemaining--;
    } else if (_timeRemaining.value == 0) {
      _isActive.value = false;
      showSummary();
    }
  }

  void toggleActive() {
    _isActive.value = !_isActive.value;
  }

  void resetGame() {
    _timeRemaining.value = _totalTime.value;
    _isActive.value = false;
    _events.clear();
    _inventory.clear();
    _currentEncounterIcon.value = "🌟";
    _currentEncounterDescription.value = "Waiting for adventure...\n";
    _eventCount.value = 0;
  }

  void addToInventory(String item, int quantity) {
    if (_inventory.containsKey(item)) {
      _inventory[item] = _inventory[item]! + quantity;
    } else {
      _inventory[item] = quantity;
    }
  }

  void _generateEvent() {
    if (_isActive.value && _timeRemaining.value > 0) {
      _eventCount++;
      if (_eventCount.value % 20 == 0) {
        _generateRestEvent();
      } else {
        int ranNumber = Random().nextInt(100) + 1;
        if (ranNumber <= 40) {
          _generateNothingEvent();
        } else if (ranNumber <= 90) {
          _generateEnemyEvent();
        } else {
          _generateTreasureEvent();
        }
      }
    }
  }

  void _generateNothingEvent() {
    _currentEncounterIcon.value = "🌟";
    _currentEncounterDescription.value = "Nothing happened...\n";
    _events.insert(
      0,
      Event(
        icon: "🌟",
        title: "Peaceful",
        description: "You continue your journey without incident.",
      ),
    );
  }

  void _generateEnemyEvent() {
    List<String> enemies = [
      "👹 Ogre",
      "🐉 Dragon",
      "💀 Skeleton",
      "🧟‍♂️ Zombie",
      "🦇 Vampire",
      "🐺 Werewolf"
    ];
    String enemy = enemies[Random().nextInt(enemies.length)];
    int damage = Random().nextInt(16) + 15; // 15-30 damage
    int exp = Random().nextInt(16) + 5; // 5-20 exp
    int gold = Random().nextInt(10) + 1; // 1-10 gold

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
            "Encountered a ${enemy.split(" ")[1]}! Took $damage damage. Gained $exp EXP and $gold Gold.",
      ),
    );
  }

  void _generateTreasureEvent() {
    List<String> treasures = [
      "💎 Gem",
      "🗡️ Sword",
      "🛡️ Shield",
      "📜 Scroll",
      "🔮 Magic Orb",
      "💍 Ring"
    ];
    String treasure = treasures[Random().nextInt(treasures.length)];
    int quantity = Random().nextInt(3) + 1; // 1-3 items
    int gold = Random().nextInt(41) + 10; // 10-50 gold

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
            "Found ${quantity}x ${treasure.split(" ")[1]}! Gained $gold Gold.\n",
      ),
    );
  }

  void _generateRestEvent() {
    int healing = Random().nextInt(31) + 20; // 20-50 healing
    _currentEncounterIcon.value = "🏕️";
    _currentEncounterDescription.value =
        "Found a safe spot to rest. Healed $healing HP.\n";

    addToInventory("❤️ HP", healing);

    _events.insert(
      0,
      Event(
        icon: "🏕️",
        title: "Rest",
        description: "Found a safe spot to rest. Healed $healing HP.\n",
      ),
    );
  }

  void showSummary() {
    _showingSummary.value = true;
    _events.insert(
      0,
      Event(
        icon: "🏁",
        title: "Summary",
        description: "Adventure completed!\n",
      ),
    );
  }

  @override
  void onClose() {
    _timer.cancel();
    _eventTimer.cancel();
    super.onClose();
  }
}

class Event {
  final String icon;
  final String title;
  final String description;

  Event({required this.icon, required this.title, required this.description});
}
