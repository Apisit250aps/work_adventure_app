import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/focus_controller.dart';

class FocusScreen extends GetView<FocusController> {
  const FocusScreen({super.key, required int totalTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
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
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       Obx(() => _buildActionButton(
            //             onPressed: controller.toggleActive,
            //             label: controller.isActive ? 'Pause' : 'Focus',
            //             color: controller.isActive
            //                 ? const Color.fromARGB(255, 255, 76, 76)
            //                 : const Color.fromARGB(255, 0, 0, 0),
            //             icon: controller.isActive
            //                 ? Icons.pause
            //                 : Icons.play_arrow,
            //           )),
            //       _buildActionButton(
            //         onPressed: controller.resetFocus,
            //         label: 'Reset',
            //         color: const Color.fromARGB(255, 0, 0, 0),
            //         icon: Icons.refresh,
            //       ),
            //       _buildActionButton(
            //         onPressed: () => Get.back(),
            //         label: 'Set Time',
            //         color: const Color.fromARGB(255, 0, 0, 0),
            //         icon: Icons.timer,
            //       ),
            //     ],
            //   ),
            // ),
          ],
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

  void _showAdventureLog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.2,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return AdventureLogBottomSheet(
              scrollController: scrollController,
            );
          },
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
            valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 0, 0, 0)),
            strokeWidth: 12,
            backgroundColor: Colors.grey[200],
          ),
          Center(
            child: Text(
              formatTime(timeRemaining),
              style: TextStyle(
                fontSize: timeRemaining > 5999
                    ? size / 5
                    : size / 4, // Adjust font size for longer time
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
    if (seconds > 5999) {
      // More than 99 minutes and 59 seconds
      int hours = max(0, seconds ~/ 3600);
      int minutes = max(0, (seconds % 3600) ~/ 60);
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } else {
      int minutes = max(0, seconds ~/ 60);
      int remainingSeconds = max(0, seconds % 60);
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
  }
}

class AdventureLogBottomSheet extends GetView<FocusController> {
  final ScrollController scrollController;

  const AdventureLogBottomSheet({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            height: 4,
            width: 40,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Adventure Log',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
                  controller: scrollController,
                  itemCount: controller.adventureLog.length,
                  itemBuilder: (context, index) {
                    final entry = controller.adventureLog[index];
                    return ListTile(
                      leading: Text(
                        entry.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(entry.description),
                      subtitle: Text(
                        '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
