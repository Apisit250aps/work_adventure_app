import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';

import 'package:work_adventure/widgets/navigate/BottomNavBar.dart';

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FocusScreenModel(),
      child: const FocusScreenContent(),
    );
  }
}

class FocusScreenContent extends StatelessWidget {
  const FocusScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FocusScreenModel>(
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Focus Adventure',
                style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: const Icon(Icons.inventory),
                onPressed: () => _showInventory(context),
              ),
            ],
          ),
          body: Container(
            color: Colors.white,
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.black, width: 2),
                            ),
                            child: CircularTimer(
                              timeRemaining: model.timeRemaining,
                              totalTime: model.totalTime,
                              size: 250,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            model.currentEncounterIcon,
                            style: const TextStyle(fontSize: 70),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              model.currentEncounterDescription,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[800]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton(
                          onPressed: model.toggleActive,
                          label: model.isActive ? 'Pause' : 'Focus',
                          color: model.isActive ? Colors.orange : Colors.green,
                          icon: model.isActive ? Icons.pause : Icons.play_arrow,
                        ),
                        _buildActionButton(
                          onPressed: model.resetGame,
                          label: 'Reset',
                          color: Colors.red,
                          icon: Icons.refresh,
                        ),
                        _buildActionButton(
                          onPressed: () => _showSetTimeModal(context),
                          label: 'Set Time',
                          color: Colors.blue,
                          icon: Icons.timer,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const BottomNavBar(
          selectedIndex: 2,
        ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  void _showSetTimeModal(BuildContext context) {
    final model = Provider.of<FocusScreenModel>(context, listen: false);
    int tempTime = model.totalTime ~/ 60;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Set Focus Time',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 20),
                  Text('$tempTime minutes',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  Slider(
                    value: tempTime.toDouble(),
                    min: 1,
                    max: 120,
                    divisions: 119,
                    onChanged: (double value) {
                      setState(() {
                        tempTime = value.round();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Set'),
                    onPressed: () {
                      model.setTime(tempTime);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

void _showInventory(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Consumer<FocusScreenModel>(
        builder: (context, model, child) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: InventoryPopup(inventory: model.inventory),
          );
        },
      );
    },
  );
}

class InventoryDialog extends StatelessWidget {
  const InventoryDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<FocusScreenModel>(context, listen: false);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: InventoryPopup(inventory: model.inventory),
    );
  }
}

class InventoryPopup extends StatelessWidget {
  final Map<String, int> inventory;

  const InventoryPopup({super.key, required this.inventory});

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, int>> inventoryList = inventory.entries.toList();

    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Inventory',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 200,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: inventoryList.length,
              itemBuilder: (context, index) {
                MapEntry<String, int> item = inventoryList[index];
                return InventorySlot(item: item.key, quantity: item.value);
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red,
            ),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class InventorySlot extends StatelessWidget {
  final String item;
  final int quantity;

  const InventorySlot({super.key, required this.item, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[700],
        border: Border.all(color: Colors.grey[600]!, width: 1),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              item.split(' ')[0],
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          if (quantity > 1)
            Positioned(
              right: 2,
              bottom: 2,
              child: Text(
                quantity.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class EmptySlot extends StatelessWidget {
  const EmptySlot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[700],
        border: Border.all(color: Colors.grey[600]!, width: 2),
      ),
    );
  }
}

class CircularTimer extends StatelessWidget {
  final int timeRemaining;
  final int totalTime;
  final double size;

  const CircularTimer({
    super.key,
    required this.timeRemaining,
    required this.totalTime,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: 1 - (timeRemaining / totalTime),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 12,
            backgroundColor: Colors.grey[200],
          ),
          Center(
            child: Text(
              formatTime(timeRemaining),
              style: TextStyle(
                fontSize: size / 4,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    int minutes = max(0, seconds ~/ 60);
    int remainingSeconds = max(0, seconds % 60);
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class FocusScreenModel extends ChangeNotifier {
  Map<String, int> _inventory = {};
  Map<String, int> get inventory => _inventory;
  int _timeRemaining = 1800;
  int _totalTime = 1800;
  bool _isActive = false;
  final List<Event> _events = [];
  String _currentEncounterIcon = "🌟";
  String _currentEncounterDescription = "Waiting for adventure...\n";
  int _eventCount = 0;
  bool _showingSummary = false;

  int get timeRemaining => _timeRemaining;
  int get totalTime => _totalTime;
  bool get isActive => _isActive;
  List<Event> get events => _events;
  String get currentEncounterIcon => _currentEncounterIcon;
  String get currentEncounterDescription => _currentEncounterDescription;
  bool get showingSummary => _showingSummary;

  late Timer _timer;
  late Timer _eventTimer;

  FocusScreenModel() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => updateTimer());
    _eventTimer =
        Timer.periodic(const Duration(seconds: 3), (_) => generateEvent());
    _inventory = {}; // Make sure it's initialized
  }

  void updateTimer() {
    if (_isActive && _timeRemaining > 0) {
      _timeRemaining--;
      notifyListeners();
    } else if (_timeRemaining == 0) {
      _isActive = false;
      showSummary();
    }
  }

  void toggleActive() {
    _isActive = !_isActive;
    notifyListeners();
  }

  void resetGame() {
    _timeRemaining = _totalTime;
    _isActive = false;
    _events.clear();
    _inventory.clear();
    _currentEncounterIcon = "🌟";
    _currentEncounterDescription = "Waiting for adventure...\n";
    _eventCount = 0;
    notifyListeners();
  }

  void setTime(int minutes) {
    _totalTime = minutes * 60;
    _timeRemaining = _totalTime;
    notifyListeners();
  }

  void addToInventory(String item, int quantity) {
    if (_inventory.containsKey(item)) {
      _inventory[item] = _inventory[item]! + quantity;
    } else {
      _inventory[item] = quantity;
    }
    notifyListeners();
  }

  void generateEvent() {
    if (_isActive && _timeRemaining > 0) {
      _eventCount++;
      if (_eventCount % 20 == 0) {
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
      notifyListeners();
    }
  }

  void generateNothingEvent() {
    _currentEncounterIcon = "🌟";
    _currentEncounterDescription = "Nothing happened...\n";
    _events.insert(
      0,
      Event(
        icon: "🌟",
        title: "Peaceful",
        description: "You continue your journey without incident.",
      ),
    );
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
    int damage = Random().nextInt(16) + 15; // 15-30 damage
    int exp = Random().nextInt(16) + 5; // 5-20 exp
    int gold = Random().nextInt(10) + 1; // 1-10 gold

    _currentEncounterIcon = enemy.split(" ")[0];
    _currentEncounterDescription =
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
    int quantity = Random().nextInt(3) + 1; // 1-3 items
    int gold = Random().nextInt(41) + 10; // 10-50 gold

    _currentEncounterIcon = treasure.split(" ")[0];
    _currentEncounterDescription =
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

  void generateRestEvent() {
    int healing = Random().nextInt(31) + 20; // 20-50 healing
    _currentEncounterIcon = "🏕️";
    _currentEncounterDescription =
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
    _showingSummary = true;
    _events.insert(
      0,
      Event(
        icon: "🏁",
        title: "Summary",
        description: "Adventure completed!\n",
      ),
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _timer.cancel();
    _eventTimer.cancel();
    super.dispose();
  }
}

class Event {
  final String icon;
  final String title;
  final String description;

  Event({required this.icon, required this.title, required this.description});
}
