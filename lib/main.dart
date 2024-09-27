import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:work_adventure/screens/auth/login_screen.dart';
import 'package:work_adventure/screens/focus_setup_screen.dart';
import 'package:work_adventure/screens/home_screen.dart';
import 'package:work_adventure/screens/quest_screen.dart';
import 'package:work_adventure/screens/work_screen.dart';

void main() {
  runApp(const WorkAdventure());
}

class WorkAdventure extends StatelessWidget {
  const WorkAdventure({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Work Adventure',
      theme: _buildTheme(),
      home: const AuthWrapper(),
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(UserController());
        Get.put(CharacterController());
      }),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        selectedIconTheme: IconThemeData(
          color: Colors.black,
        ),
        selectedLabelStyle: TextStyle(color: Colors.black),
        selectedItemColor: Colors.black,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.white, // Choose a more distinct seed color
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }
}

class AuthWrapper extends GetWidget<UserController> {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isAuthenticated.value
        ? const HomeScreen()
        : const LoginScreen());
  }
}

class PageControllerX extends GetxController {
  var pageIndex = 0.obs;
  PageController pageController = PageController();

  void changePage(int index) {
    pageIndex.value = index;
    pageController.jumpToPage(index);
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }
}

class OperatorScreen extends StatefulWidget {
  const OperatorScreen({super.key});

  @override
  State<OperatorScreen> createState() => _OperatorScreenState();
}

class _OperatorScreenState extends State<OperatorScreen> {
  final PageControllerX controller = Get.put(PageControllerX());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (index) {
          controller.changePage(index); // อัปเดตสถานะเมื่อเปลี่ยนหน้า
        },
        children: const <Widget>[
          WorkScreen(),
          FocusSetupScreen(),
          QuestScreen(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex:
              controller.pageIndex.value, // ใช้ GetX เพื่อแสดงสถานะปัจจุบัน
          onTap:
              controller.changePage, // เปลี่ยนหน้าด้วยการกด BottomNavigationBar
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Boxicons.bx_home_circle),
              activeIcon: Icon(Boxicons.bxs_home_circle),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Boxicons.bx_time),
              activeIcon: Icon(Boxicons.bxs_time),
              label: 'Focus',
            ),
            BottomNavigationBarItem(
              icon: Icon(Boxicons.bx_receipt),
              activeIcon: Icon(Boxicons.bxs_receipt),
              label: 'Quest',
            ),
          ],
        ),
      ),
    );
  }
}
