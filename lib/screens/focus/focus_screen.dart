import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/focus_controller.dart';
import 'package:work_adventure/controllers/characteroutloop_controller.dart';
import 'package:collection/collection.dart';

class FocusScreen extends GetView<FocusController> {
  const FocusScreen({super.key, required int totalTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
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
                          child: Obx(
                            () => CircularTimer(
                              timeRemaining: controller.timeRemaining,
                              totalTime: controller.totalTime,
                              size: 250,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Obx(
                          () => Text(
                            controller.currentEncounterIcon,
                            style: const TextStyle(fontSize: 70),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Obx(() => _buildEncounterDescription()),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Add the HP and EXP bars at the bottom
            const HPEXPBars(),
          ],
        ),
      ),
    );
  }

  Widget _buildEncounterDescription() {
    String description = controller.currentEncounterDescription;
    List<InlineSpan> textSpans = [];

    // สร้าง RegExp ที่รวมทั้ง emoji ของมอนสเตอร์และไอเทม
    RegExp combinedRegex = RegExp(
        r'(🐺|🦇|🐗|🦊|🐍|🧟|💀|🧛|🐲|🧙|🐉|🌑|🧛🏻‍♂️|🧙🏻|⏳|🗡️|🌙|' +
            r'📦|👝|🪙|💍|⛓️|🗃️|🎒|💰|💎|🦪|🏺|🎇|🔶|👑|🧬|⏳|🌌|🌟|💫|🔮)\s*([^\n]+)');

    Iterable<RegExpMatch> matches = combinedRegex.allMatches(description);
    int lastEnd = 0;

    for (RegExpMatch match in matches) {
      if (match.start > lastEnd) {
        textSpans
            .add(TextSpan(text: description.substring(lastEnd, match.start)));
      }

      String emoji = match.group(1)!;
      String fullName = match.group(2)!;

      // ตรวจสอบว่าเป็นมอนสเตอร์หรือไอเทม
      var entity = controller.enemy.expand((list) => list).firstWhereOrNull(
                (m) => m.emoji == emoji && fullName.startsWith(m.name),
              ) ??
          controller.items.expand((list) => list).firstWhereOrNull(
                (i) => i.emoji == emoji && fullName.startsWith(i.name),
              );

      if (entity != null) {
        String name =
            entity is MonsterName ? entity.name : (entity as ItemName).name;
        Color color =
            entity is MonsterName ? entity.color : (entity as ItemName).color;
        textSpans.add(TextSpan(
          text: "$emoji $name",
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ));
        // Add remaining text (if any)
        if (fullName.length > name.length) {
          textSpans.add(TextSpan(text: fullName.substring(name.length)));
        }
      } else {
        textSpans.add(TextSpan(text: "$emoji $fullName"));
      }

      lastEnd = match.end;
    }

    if (lastEnd < description.length) {
      textSpans.add(TextSpan(text: description.substring(lastEnd)));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 18, color: Colors.grey[800]),
        children: textSpans,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget buildActionButton({
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
}

void showAdventureLog(BuildContext context) {
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
      int hours = math.max(0, seconds ~/ 3600);
      int minutes = math.max(0, (seconds % 3600) ~/ 60);
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    } else {
      int minutes = math.max(0, seconds ~/ 60);
      int remainingSeconds = math.max(0, seconds % 60);
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

class ProgressBar extends StatelessWidget {
  final int value;
  final int max;
  final Color color;
  final String label;
  final bool isReversed;
  final Duration animationDuration;

  const ProgressBar({
    super.key,
    required this.value,
    required this.max,
    required this.color,
    required this.label,
    this.isReversed = false,
    this.animationDuration = const Duration(milliseconds: 1000),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 20,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        TweenAnimationBuilder<double>(
          duration: animationDuration,
          tween: Tween(begin: 0, end: value / max),
          curve: Curves.easeInOut,
          builder: (context, tweenValue, child) {
            return AnimatedAlign(
              duration: animationDuration,
              alignment:
                  isReversed ? Alignment.centerRight : Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: tweenValue,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.7), color],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: CustomPaint(
                    painter:
                        ShimmerPainter(color: Colors.white.withOpacity(0.25)),
                  ),
                ),
              ),
            );
          },
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Container(
            key: ValueKey<int>(value),
            height: 20,
            alignment:
                isReversed ? Alignment.centerRight : Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$label: $value/$max',
              style: TextStyle(
                color: color.computeLuminance() > 0.5
                    ? Colors.black
                    : Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ShimmerPainter extends CustomPainter {
  final Color color;

  ShimmerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    for (double i = 0; i < size.width; i++) {
      path.lineTo(i, math.sin(i / 5) * 3 + 10);
    }
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class HPEXPBars extends StatelessWidget {
  final double staminaBarWidth;
  final double hpBarWidth;
  final double expBarWidth;

  const HPEXPBars({
    super.key,
    this.staminaBarWidth = 1.0,
    this.hpBarWidth = 0.35,
    this.expBarWidth = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    final characterbar = Get.find<CharacterbarController>();

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Obx(() {
        final (healthNow, healthMax) = characterbar.healthBar();
        final (expNow, expMax) = characterbar.expBar();
        final (staminaNow, staminaMax) = characterbar.spBar();

        return Column(
          children: [
            // Stamina bar
            Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: staminaBarWidth,
                child: ProgressBar(
                  value: expNow,
                  max: expMax,
                  color: const Color(0xFF5B84B1),
                  label: 'EXP',
                ),
              ),
            ),
            const SizedBox(height: 0),
            // HP and EXP bars
            Row(
              children: [
                Expanded(
                  flex: (hpBarWidth * 100).toInt(),
                  child: ProgressBar(
                    value: healthNow,
                    max: healthMax,
                    color: const Color(0xFFFC766A),
                    label: 'HP',
                  ),
                ),
                Expanded(
                  flex: (expBarWidth * 100).toInt(),
                  child: ProgressBar(
                    value: staminaNow,
                    max: staminaMax,
                    color: const Color(0xFFFFD700),
                    label: 'SP',
                    isReversed: true,
                  ),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
