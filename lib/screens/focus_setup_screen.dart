import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/focus_controller.dart';
import 'package:work_adventure/screens/focus_screen.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:work_adventure/widgets/navigate/AppNavBar.dart';
import 'package:work_adventure/widgets/button/form_button.dart';
import 'package:work_adventure/widgets/navigate/AppNavBar.dart';

class FocusSetupScreen extends StatelessWidget {
  final FocusController controller = Get.put(FocusController());

  FocusSetupScreen({super.key}) {
    controller.initFocus(10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const AppBarNav(
            title: "Focus",
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => Text(
                        '${controller.totalTime ~/ 60}',
                        style: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      )),
                  const Text(
                    'minutes',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Obx(() => CustomSlider(
                        value: (controller.totalTime / 60).toDouble(),
                        onChanged: (double value) {
                          controller.initFocus(value.round());
                        },
                      )),
                  const SizedBox(height: 60),
                  SquareButton(
                    onClick: () {
                      Get.to(() => FocusScreen(
                            totalTime: controller.totalTime,
                          ));
                    },
                    isLoading: false,
                    buttonText: "Start Focus",
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const CustomSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.black,
        inactiveTrackColor: Colors.grey[300],
        trackShape: const RoundedRectSliderTrackShape(),
        trackHeight: 2.0,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 8.0,
        ),
        thumbColor: Colors.black,
        overlayColor: Colors.transparent,
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
        tickMarkShape: const RoundSliderTickMarkShape(),
        activeTickMarkColor: Colors.black,
        inactiveTickMarkColor: Colors.transparent,
        valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: Colors.black,
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      child: Slider(
        value: value.clamp(10, 120),
        min: 10,
        max: 120,
        divisions: 110,
        label: '${value.round()} min',
        onChanged: (newValue) {
          onChanged(newValue.roundToDouble());
        },
      ),
    );
  }
}
