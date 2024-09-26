import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_adventure/controllers/UserController.dart';
import 'package:work_adventure/screens/auth/login_screen.dart';
import 'package:work_adventure/screens/work_screen.dart';

void main() {
  runApp(const WorkAdventure());
}

class WorkAdventure extends StatelessWidget {
  const WorkAdventure({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());
    return GetMaterialApp(
      title: 'Work Adventure',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: Obx(() {
        return userController.isAuthenticated.value
            ? const WorkScreen()
            : const LoginScreen();
      }),
      debugShowCheckedModeBanner: false,
    );
  }
}
