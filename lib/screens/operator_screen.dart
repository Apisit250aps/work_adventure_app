import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';

import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/page_controller.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/screens/focus/focus_screen.dart';
import 'package:work_adventure/screens/work/work_screen.dart';
import 'package:work_adventure/widgets/ui/buttons.dart';
import 'package:work_adventure/widgets/ui/forms/inputs.dart';
import 'package:work_adventure/widgets/ui/forms/work_create_form.dart';
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
    return Scaffold(
      appBar: _buildAppBar(),
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.changePage,
        children: pageWidget,
      ),
      floatingActionButton: _buildFloatingActionButton(context),
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
          titleList[controller.pageIndex.value],
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
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
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
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
        onPressed: () => _handleFloatingActionButton(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Boxicons.bx_plus, color: Colors.white),
      ),
    );
  }

  void _handleFloatingActionButton(BuildContext context) {
    final currentPage = controller.pageIndex.value;
    if (currentPage < titleList.length) {
      switch (titleList[currentPage].toLowerCase()) {
        case "work":
          _createWorkSheets(context);
          break;
        case "focus":
          // Add focus-related action here
          break;
        default:
          // Handle unexpected cases
          print("Unexpected page: ${titleList[currentPage]}");
      }
    }
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
