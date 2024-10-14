import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/widgets/ui/forms/character_form.dart';

class CharacterCreateScreen extends GetView<CharacterController> {
  const CharacterCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: backgroundColor,
        title: const Text(
          "Create a new character",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CharacterForm(),
            ],
          ),
        ),
    );
  }
}
