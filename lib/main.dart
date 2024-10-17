import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:work_adventure/models/hive/quest_hive_model.dart';
import 'package:work_adventure/screens/auth/login_screen.dart';
import 'package:work_adventure/screens/auth/register_screen.dart';
import 'package:work_adventure/screens/character/character_screen.dart';
import 'package:work_adventure/screens/character/character_create_screen.dart';
import 'package:work_adventure/screens/character/character_status_screen.dart';
import 'package:work_adventure/screens/operator_screen.dart';
import 'package:work_adventure/screens/todo/task_screen.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';
import 'package:work_adventure/utils/get_bindings.dart';

void main() async{
  await Hive.initFlutter();
  Hive.registerAdapter(QuestAdapter());
  runApp(const WorkAdventure());
}

class WorkAdventure extends StatelessWidget {
  const WorkAdventure({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Work Adventure',
      theme: themeData,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const AuthWrapper(),
          binding: AuthWarpBinding(),
        ),
        GetPage(
          name: '/operator',
          page: () => OperatorScreen(),
          binding: OperatorBinding(),
        ),
        GetPage(
          name: '/characters',
          page: () => const CharacterScreen(),
          // binding: CharacterBinding(),
        ),
        GetPage(
          name: '/characterCreate',
          page: () => const CharacterCreateScreen(),
        ),
        GetPage(
          name: '/characterStatus',
          page: () => const CharacterStatusScreen(),
        ),
        GetPage(
          name: '/login',
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: '/register',
          page: () => const RegisterScreen(),
        ),
        GetPage(
          name: '/tasks',
          page: () => const TaskScreen(),
          binding: TaskBinding(),
        ),
      ],
      initialBinding: BindingsBuilder(() {
        Get.put(RestServiceController());
        Get.put(ApiService());
        Get.put(UserController());
        Get.put(CharacterController());
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed('/characters');
        });
        return Container();
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed('/login');
        });
        return Container();
      }
    });
  }
}
