import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/focus_controller.dart';
import 'package:work_adventure/screens/focus_screen.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:work_adventure/widgets/navigate/AppNavBar.dart';

class FocusSetupScreen extends StatelessWidget {
  const FocusSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final focusController = Get.put(FocusController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Setup'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Set Focus Time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Obx(
              () => Text(
                '${(focusController.totalTime.value ~/ 60).toString().padLeft(2, '0')} minutes',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => Slider(
                value: (focusController.totalTime.value ~/ 60).toDouble(),
                min: 1,
                max: 120,
                divisions: 119,
                onChanged: (double value) {
                  focusController.setFocusTime(value.toInt());
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Start'),
              onPressed: () {
                focusController
                    .initFocus(focusController.totalTime.value ~/ 60);
                Get.to(() => const FocusScreen(totalTime: null,));
              },
            ),
          ],
        ),
      ),
    );
  }
}

extension on int {
  get value => null;
}
