import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/page_controller.dart';
import 'package:work_adventure/screens/focus/focus_screen.dart';
import 'package:work_adventure/screens/option/setting_screen.dart';
import 'package:work_adventure/screens/todo/work_screen.dart';
import 'package:work_adventure/widgets/ui/forms/work_create_form.dart';
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
      widget: const FocusScreen(),
      floatingActionButton: (context) => const FocusFloatingActionButton(),
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
            Get.to(() => const SettingScreen());
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

class FocusFloatingActionButton extends StatelessWidget {
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
          // เพิ่มการทำงานสำหรับ Focus screen ที่นี่
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.timer, color: Colors.white),
      ),
    );
  }
}
