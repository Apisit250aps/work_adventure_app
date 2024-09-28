import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/focus_controller.dart';
import 'dart:math';

class FocusScreen extends GetView<FocusController> {
  const FocusScreen({Key? key, required int totalTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                        child: Obx(() => CircularTimer(
                              timeRemaining: controller.timeRemaining,
                              totalTime: controller.totalTime,
                              size: 250,
                            )),
                      ),
                      const SizedBox(height: 30),
                      Obx(() => Text(
                            controller.currentEncounterIcon,
                            style: const TextStyle(fontSize: 70),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Obx(() => Text(
                              controller.currentEncounterDescription,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[800]),
                            )),
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
                    Obx(() => _buildActionButton(
                          onPressed: controller.toggleActive,
                          label: controller.isActive ? 'Pause' : 'Focus',
                          color: controller.isActive
                              ? const Color.fromARGB(255, 255, 76, 76)
                              : const Color.fromARGB(255, 0, 0, 0),
                          icon: controller.isActive
                              ? Icons.pause
                              : Icons.play_arrow,
                        )),
                    _buildActionButton(
                      onPressed: controller.resetFocus,
                      label: 'Reset',
                      color: const Color.fromARGB(255, 0, 0, 0),
                      icon: Icons.refresh,
                    ),
                    _buildActionButton(
                      onPressed: () => Get.back(),
                      label: 'Set Time',
                      color: const Color.fromARGB(255, 0, 0, 0),
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

  void _showInventory(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Obx(() => InventoryPopup(inventory: controller.inventory)),
        );
      },
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
            valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 0, 0, 0)),
            strokeWidth: 12,
            backgroundColor: Colors.grey[200],
          ),
          Center(
            child: Text(
              formatTime(timeRemaining),
              style: TextStyle(
                fontSize: size / 4,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0),
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
