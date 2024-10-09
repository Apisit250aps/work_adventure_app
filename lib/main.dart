import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:work_adventure/screens/auth/login_screen.dart';
import 'package:work_adventure/screens/character/character_screen.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';

void main() {
  runApp(const WorkAdventure());
}

class WorkAdventure extends StatelessWidget {
  const WorkAdventure({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      home: const AuthWrapper(),
      initialBinding: BindingsBuilder(() {
        Get.put(RestServiceController());
        Get.put(ApiService());
        Get.put(UserController());
      }),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthWrapper extends GetWidget<UserController> {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (controller.isAuthenticated.value) {
        return const CharacterScreen();
      } else {
        return const LoginScreen();
      }
    });
  }
}
