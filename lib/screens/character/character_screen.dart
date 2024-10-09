import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/user_controller.dart';

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find<UserController>();
    final CharacterController characterController =
        Get.put(CharacterController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text(
          "Character",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: userController.logout,
          )
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: characterController.charactersSlot.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                  characterController.charactersSlot[index].name as String),
            );
          },
        ),
      ),
    );
  }
}
