import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/page_controller.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:work_adventure/screens/focus/focus_screen.dart';
import 'package:work_adventure/screens/work/work_screen.dart';
import 'package:work_adventure/widgets/ui/navigate/bottom_nav.dart';

class OperatorScreen extends GetView<PageControllerX> {
  OperatorScreen({super.key});

  final List<String> titleList = ["Work", "Focus"];
  final List<Widget> pageWidget = [
    const WorkScreen(),
    const FocusScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Obx(
          () => Text(
            titleList[controller.pageIndex.value],
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: userController.logout,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(baseColor),
              elevation: const WidgetStatePropertyAll(5),
              iconSize: const WidgetStatePropertyAll(28),
            ),
            icon: const Icon(
              Boxicons.bx_dots_vertical_rounded,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.changePage,
        children: pageWidget,
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          onPressed: () {
            // Add your onPressed action here
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Boxicons.bx_plus, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => BottomNavigation(
          currentIndex: controller.pageIndex.value,
          onTap: controller.changePage,
        ),
      ),
    );
  }
}
