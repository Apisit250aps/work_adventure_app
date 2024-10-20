import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/special_controller.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/models/character_model.dart';

class CharacterStatusScreen extends GetWidget<SpecialController> {
  const CharacterStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CharacterController characterController = Get.find();
    final character = characterController.characterSelect.value;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.specialRefresh,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              CharacterInfoCard(
                character: character,
                characterController: characterController,
                controller: controller,
              ),
              const SizedBox(height: 20),
              const Text(
                'Character Stats',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              ...buildStatBars(),
            ],
          );
        }),
      ),
    );
  }

  List<Widget> buildStatBars() {
    final CharacterController characterController = Get.find();
    final stats = [
      (
        'STR',
        controller.special.value.strength,
        '🫁  🛡️  ❤️  (ลดความเสียหาย)'
      ),
      ('PER', controller.special.value.perception, '💰  💎  (ทรัพยากร)'),
      (
        'END',
        controller.special.value.endurance,
        '❤️  🏕️  🩸  ⌚  (เอาตัวรอด)'
      ),
      (
        'CHA',
        controller.special.value.charisma,
        '📜  🏕️  🍀  💰  (ลดความเสี่ยง)'
      ),
      (
        'INT',
        controller.special.value.intelligence,
        '🧿  🫁  🏕️  ⌚  (ค่าประสบการณ์)'
      ),
      ('AGI', controller.special.value.agility, '⚔️  ⌚  🩸  (เร่งเวลา)'),
      ('LCK', controller.special.value.luck, '🍀  (ดวงดี)'),
    ];

    return stats
        .map((stat) => StatBar(
              label: stat.$1,
              value: stat.$2,
              description: stat.$3, // เพิ่มคำอธิบาย
              onIncrement: () {
                controller.incrementSpecial(stat.$1);
                if (characterController.characterSelect.value.statusPoint! >
                    0) {
                  characterController.pointDecrease();
                }
              },
            ))
        .toList();
  }
}

class CharacterInfoCard extends StatelessWidget {
  final Character character;
  final CharacterController characterController;
  final SpecialController controller;

  const CharacterInfoCard({
    super.key,
    required this.character,
    required this.characterController,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              characterController.characterImages[character.avatarIndex ?? 0],
              fit: BoxFit.cover,
            ),
          ),
        ),
        // CircleAvatar(
        //   radius: 40,
        //   backgroundImage: AssetImage(
        //     characterController.characterImages[character.avatarIndex ?? 0],
        //   ),
        // ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    character.name ?? '',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      character.className ?? '',
                      style: TextStyle(
                        color: Colors.red[400],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(
                      'Level',
                      characterController
                          .calculateLevel(
                              controller.characterSelect.value.exp ?? 0)
                          .toString()),
                  _buildInfoItem('Focus Points',
                      controller.characterSelect.value.focusPoint.toString()),
                  _buildInfoItem('Status Points',
                      controller.characterSelect.value.statusPoint.toString()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class StatBar extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onIncrement;
  final String description; // เพิ่มพารามิเตอร์นี้

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    required this.onIncrement,
    required this.description, // เพิ่มพารามิเตอร์นี้
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        // เปลี่ยนจาก Row เป็น Column
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 40,
                child: Text(label,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: value / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    minHeight: 10,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 30,
                child: Text(value.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 20),
                onPressed: onIncrement,
                padding: const EdgeInsets.all(10),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          Padding(
            // เพิ่ม Text สำหรับคำอธิบาย
            padding: const EdgeInsets.only(left: 55, top: 0),
            child: Text(
              description,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
