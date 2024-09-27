import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:work_adventure/screens/auth/login_screen.dart';
import 'package:work_adventure/screens/home_screen.dart';
// import 'package:work_adventure/screens/work_screen.dart';

void main() {
  runApp(const WorkAdventure());
}
class WorkAdventure extends StatelessWidget {
  const WorkAdventure({Key? key}) : super(key: key);

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
      textTheme: GoogleFonts.poppinsTextTheme(),
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue, // Choose a more distinct seed color
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      // Add more theme customizations here
    );
  }
}

class AuthWrapper extends GetWidget<UserController> {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isAuthenticated.value
      ? const HomeScreen()
      : const LoginScreen()
    );
  }
}