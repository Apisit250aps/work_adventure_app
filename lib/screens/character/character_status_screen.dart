import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/special_controller.dart';

class CharacterStatusScreen extends GetWidget<SpecialController> {
  CharacterStatusScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Status",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/characters/dog.png",
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Dog",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                "Student",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 50),
              upStatusBar("STR", controller.special.value.strength),
              upStatusBar("PER", controller.special.value.perception),
              upStatusBar("END", controller.special.value.endurance),
              upStatusBar("CHA", controller.special.value.charisma),
              upStatusBar("INT", controller.special.value.intelligence),
              upStatusBar("AGI", controller.special.value.agility),
              upStatusBar("LUK", controller.special.value.luck),
            ],
          ),
        );
      }),
    );
  }

  Widget upStatusBar(String status, int value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 75,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(status)],
            ),
          ),
          Row(
            children: [
              IconButton(
                style: ButtonStyle(
                  elevation: const WidgetStatePropertyAll(5),
                  backgroundColor: WidgetStatePropertyAll(baseColor),
                ),
                onPressed: () => controller.decrementSpecial(status),
                icon: const Icon(Boxicons.bx_minus),
              ),
              Container(
                width: 75,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("$value")],
                ),
              ),
              IconButton(
                style: ButtonStyle(
                  elevation: const  WidgetStatePropertyAll(5),
                  backgroundColor: WidgetStatePropertyAll(baseColor),
                ),
                onPressed: () => controller.incrementSpecial(status),
                icon: const Icon(Boxicons.bx_plus),
              )
            ],
          )
        ],
      ),
    );
  }
}