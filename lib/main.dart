import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/page_controller.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/screens/auth/login_screen.dart';
import 'package:work_adventure/screens/focus_setup_screen.dart';
import 'package:work_adventure/screens/home_screen.dart';
import 'package:work_adventure/screens/quest_screen.dart';
import 'package:work_adventure/screens/work_screen.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';

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
        Get.put(RestServiceController());
        Get.put(ApiService());
        Get.put(UserController());
        Get.put(CharacterController());
        Get.delete<WorkController>();
      }),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      cardTheme: const CardTheme(
        color: Colors.white,
      ),
      dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      datePickerTheme: const DatePickerThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          backgroundColor: Colors.white),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        iconSize: 24,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          iconSize: const WidgetStatePropertyAll(24),
          iconColor: const WidgetStatePropertyAll(Colors.black),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              side: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(
                8,
              ),
            ),
          ),
        ),
      ),
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
      textTheme: GoogleFonts.itimTextTheme(),
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
    return Obx(() {
      // ถ้า controller.isLoading เป็น true แสดงว่าอยู่ในระหว่างตรวจสอบการล็อกอิน
      if (controller.isLoading.value) {
        return Scaffold(
          body: Center(
            child: Image.asset(
              'assets/gifs/slime_loading.gif', // แสดง GIF ระหว่างโหลด
              width: 64,
            ),
          ),
        );
      } else if (controller.isAuthenticated.value) {
        return const HomeScreen(); // ถ้า authenticated เปลี่ยนไปหน้า HomeScreen
      } else {
        return const LoginScreen(); // ถ้าไม่ได้ authenticated เปลี่ยนไปหน้า LoginScreen
      }
    });
  }
}

class OperatorScreen extends StatefulWidget {
  const OperatorScreen({super.key});

  @override
  State<OperatorScreen> createState() => _OperatorScreenState();
}

class _OperatorScreenState extends State<OperatorScreen> {
  final PageControllerX controller = Get.put(PageControllerX());
  final WorkController workController = Get.put(WorkController());
  
  //
  final List<String> titleList = ["Work", "Focus", "Quests"];
  final List<Widget> pageWidget = [
    const WorkScreen(),
    const FocusSetupScreen(),
    const QuestScreen(),
  ];

  String onTitle = "Work";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          onTitle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 36,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: const [
          IconButton.outlined(
            onPressed: null,
            icon: Icon(Boxicons.bx_menu),
          )
        ],
      ),
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (index) {
          controller.changePage(index); // อัปเดตสถานะเมื่อเปลี่ยนหน้า
          setState(() {
            onTitle = titleList[index];
          });
        },
        children: pageWidget,
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
