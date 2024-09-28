import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/focus_controller.dart';

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key, required totalTime});

  @override
  Widget build(BuildContext context) {
    final focusController = Get.find<FocusController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Adventure'),
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
                          timeRemaining: focusController.timeRemaining,
                          totalTime: focusController.totalTime,
                          size: 250,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Obx(
                        () => Text(
                          focusController.currentEncounterIcon,
                          style: const TextStyle(fontSize: 70),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Obx(
                          () => Text(
                            focusController.currentEncounterDescription,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[800]),
                          ),
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
                      onPressed: focusController.toggleActive,
                      label: focusController.isActive ? 'Pause' : 'Focus',
                      color: focusController.isActive
                          ? Colors.orange
                          : Colors.green,
                      icon: focusController.isActive
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    _buildActionButton(
                      onPressed: focusController.resetGame,
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
    final focusController = Get.find<FocusController>();
    int tempTime = focusController.totalTime.value ~/ 60;

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
                  Obx(
                    () => Text('$tempTime minutes',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
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
                      focusController.setFocusTime(tempTime);
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

  void _showInventory(BuildContext context) {
    final focusController = Get.find<FocusController>();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return InventoryDialog(inventory: focusController.inventory);
      },
    );
  }
}

extension on int {
  get value => null;
}

class InventoryDialog extends StatelessWidget {
  final Map<String, int> inventory;

  const InventoryDialog({super.key, required this.inventory});

  @override
  Widget build(BuildContext context) {
    inventory.entries.toList();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: InventoryPopup(inventory: inventory),
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

class CircularTimer extends StatelessWidget {
  final int timeRemaining;
  final int totalTime;
  final double size;

  const CircularTimer({super.key, 
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
              _formatTime(timeRemaining),
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

  String _formatTime(int seconds) {
    int minutes = max(0, seconds ~/ 60);
    int remainingSeconds = max(0, seconds % 60);
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
