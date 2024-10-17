import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/focus_controller.dart';
import 'package:work_adventure/controllers/page_controller.dart';
import 'package:work_adventure/screens/character/character_status_screen.dart';
import 'package:work_adventure/screens/focus/focus_screen.dart';
import 'package:work_adventure/screens/todo/work_screen.dart';
import 'package:work_adventure/screens/user/quest_screen.dart';
import 'package:work_adventure/widgets/ui/buttons.dart';
import 'package:work_adventure/widgets/ui/forms/work/work_create_form.dart';
import 'package:work_adventure/widgets/ui/navigate/bottom_nav.dart';

class OperatorScreen extends GetView<PageControllerX> {
  OperatorScreen({super.key});

  final List<PageData> pages = [
    PageData(
      title: "Work",
      widget: const WorkScreen(),
      floatingActionButton: (context) => const WorkFloatingActionButton(),
    ),
    PageData(
      title: "Focus",
      widget: const FocusScreen(
        totalTime: 3600,
      ),
      floatingActionButton: (context) => const FocusFloatingActionButton(),
    ),
    PageData(
      title: "Dairy Quests",
      widget: DailyQuestScreen(),
      floatingActionButton: (context) => const FocusFloatingActionButton(),
    ),
    PageData(
      title: "Status",
      widget: const CharacterStatusScreen(),
      floatingActionButton: (context) =>  Container(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.changePage,
        children: pages.map((page) => page.widget).toList(),
      ),
      floatingActionButton: Obx(() =>
          pages[controller.pageIndex.value].floatingActionButton(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => BottomNavigation(
          currentIndex: controller.pageIndex.value,
          onTap: controller.changePage,
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      centerTitle: true,
      title: Obx(
        () => Text(
          pages[controller.pageIndex.value].title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.toNamed("/characterStatus");
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(baseColor),
            elevation: const WidgetStatePropertyAll(5),
            iconSize: const WidgetStatePropertyAll(28),
          ),
          icon: const Icon(Icons.more_vert),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}

class PageData {
  final String title;
  final Widget widget;
  final Widget Function(BuildContext) floatingActionButton;

  PageData({
    required this.title,
    required this.widget,
    required this.floatingActionButton,
  });
}

class WorkFloatingActionButton extends StatelessWidget {
  const WorkFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: FloatingActionButton(
        onPressed: () => _createWorkSheets(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _createWorkSheets(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.75,
          expand: false,
          builder: (_, controller) {
            return const WorkCreateForm();
          },
        );
      },
    );
  }
}

class FocusFloatingActionButton extends GetWidget<FocusController> {
  const FocusFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: FloatingActionButton(
        onPressed: () {
          // เพิ่มการทำงานสำหรับ Focus screen ที่นี่;
          _focusSetupSheets(context);
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.timer, color: Colors.white),
      ),
    );
  }

  void _focusSetupSheets(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.75,
          expand: false,
          builder: (_, contexts) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimerFrame(),
                  const SizedBox(height: 40),
                  _buildTimeDisplay(),
                  const SizedBox(height: 20),
                  _buildFocusEstimate(),
                  const SizedBox(height: 20),
                  GradientButton(
                    onPressed: controller.toggleActive,
                    child: const Text("Start"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimerFrame() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTimeWheel(
            value: controller.timeRemaining ~/ 3600,
            maxValue: 8, // Changed to 8 hours max
            onChanged: (value) {
              int newTotalMinutes =
                  value * 60 + (controller.timeRemaining ~/ 60) % 60;
              controller.initFocus(
                  newTotalMinutes.clamp(10, 480)); // 480 minutes = 8 hours
            },
            label: 'hours',
            initialItem: 0,
          ),
          const SizedBox(width: 20),
          _buildTimeWheel(
            value: (controller.timeRemaining ~/ 60) % 60,
            maxValue: 59,
            onChanged: (value) {
              int newTotalMinutes =
                  (controller.timeRemaining ~/ 3600) * 60 + value;
              controller.initFocus(
                newTotalMinutes.clamp(10, 480),
              ); // 480 minutes = 8 hours
            },
            label: 'minutes',
            initialItem: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeWheel({
    required int value,
    required int maxValue,
    required Function(int) onChanged,
    required String label,
    required int initialItem,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          width: 80,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 50,
            perspective: 0.005,
            diameterRatio: 1.2,
            physics: const FixedExtentScrollPhysics(),
            controller: FixedExtentScrollController(initialItem: initialItem),
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: maxValue + 1,
              builder: (context, index) {
                return Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: index == value ? 30 : 24,
                      fontWeight:
                          index == value ? FontWeight.bold : FontWeight.normal,
                      color: index == value ? Colors.black : Colors.grey[400],
                    ),
                    child: Text(
                      index.toString().padLeft(2, '0'),
                    ),
                  ),
                );
              },
            ),
            onSelectedItemChanged: onChanged,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeDisplay() {
    return Obx(
      () => TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 300),
        tween: Tween(begin: 0, end: 1),
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.scale(
              scale: 0.5 + (value * 0.5),
              child: child,
            ),
          );
        },
        child: Text(
          '${(controller.timeRemaining ~/ 3600).toString().padLeft(2, '0')}:${((controller.timeRemaining ~/ 60) % 60).toString().padLeft(2, '0')}',
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildFocusEstimate() {
    return Obx(() {
      final minutes = controller.timeRemaining ~/ 60;
      String estimate;
      Color color;
      IconData icon;

      if (minutes < 10) {
        estimate = "Quick zap";
        color = Colors.yellow[700]!;
        icon = Boxicons.bxs_bolt;
      } else if (minutes < 15) {
        estimate = "Micro boost";
        color = Colors.blue[300]!;
        icon = Boxicons.bxs_zap;
      } else if (minutes < 20) {
        estimate = "Swift sprint";
        color = Colors.green[400]!;
        icon = Boxicons.bx_run;
      } else if (minutes < 25) {
        estimate = "Turbo focus";
        color = Colors.orange[300]!;
        icon = Boxicons.bxs_dashboard;
      } else if (minutes < 30) {
        estimate = "Power burst";
        color = Colors.red[300]!;
        icon = Boxicons.bxs_battery_charging;
      } else if (minutes < 40) {
        estimate = "Focused flow";
        color = Colors.purple[300]!;
        icon = Boxicons.bx_water;
      } else if (minutes < 50) {
        estimate = "Productivity push";
        color = Colors.teal[400]!;
        icon = Boxicons.bx_trending_up;
      } else if (minutes < 60) {
        estimate = "Concentration hour";
        color = Colors.indigo[400]!;
        icon = Boxicons.bxs_hourglass;
      } else if (minutes < 75) {
        estimate = "Deep dive";
        color = Colors.blue[600]!;
        icon = Boxicons.bx_moon;
      } else if (minutes < 90) {
        estimate = "Intense immersion";
        color = Colors.deepPurple[400]!;
        icon = Boxicons.bxs_bulb;
      } else if (minutes < 105) {
        estimate = "Productivity peak";
        color = Colors.green[600]!;
        icon = Boxicons.bx_trending_up;
      } else if (minutes < 120) {
        estimate = "Focus marathon";
        color = Colors.orange[600]!;
        icon = Boxicons.bxs_timer;
      } else if (minutes < 140) {
        estimate = "Zen mode";
        color = Colors.blueGrey[400]!;
        icon = Boxicons.bxs_tree;
      } else if (minutes < 160) {
        estimate = "Ultra concentration";
        color = Colors.red[700]!;
        icon = Boxicons.bxs_bullseye;
      } else if (minutes < 180) {
        estimate = "Productivity odyssey";
        color = Colors.purple[600]!;
        icon = Boxicons.bxs_rocket;
      } else if (minutes < 210) {
        estimate = "Focus titan";
        color = Colors.amber[800]!;
        icon = Boxicons.bxs_crown;
      } else if (minutes < 240) {
        estimate = "Mental marathon";
        color = Colors.lightBlue[800]!;
        icon = Boxicons.bxs_brain;
      } else if (minutes < 300) {
        estimate = "Epic endurance";
        color = Colors.deepOrange[600]!;
        icon = Boxicons.bxs_trophy;
      } else if (minutes < 360) {
        estimate = "Legendary focus";
        color = Colors.indigo[700]!;
        icon = Boxicons.bxs_star;
      } else if (minutes < 420) {
        estimate = "Transcendent session";
        color = Colors.deepPurple[800]!;
        icon = Boxicons.bxs_planet;
      } else if (minutes < 480) {
        estimate = "Superhuman focus";
        color = Colors.teal[800]!;
        icon = Boxicons.bxs_meteor;
      } else {
        estimate = "Time lord mastery";
        color = const Color.fromARGB(255, 0, 0, 0);
        icon = Boxicons.bx_shape_circle;
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 18,
              color: color,
              fontWeight: FontWeight.w600,
            ),
            child: Text(estimate),
          ),
        ],
      );
    });
  }
}
