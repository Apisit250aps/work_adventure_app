import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/special_controller.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/models/character_model.dart';

class CharacterStatusScreen extends GetWidget<SpecialController> {
  const CharacterStatusScreen({Key? key}) : super(key: key);

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
              const SizedBox(height: 24),
              const Text(
                'Character Stats',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              ...buildStatBars(),
            ],
          );
        }),
      ),
    );
  }

  List<Widget> buildStatBars() {
    final stats = [
      ('STR', controller.special.value.strength),
      ('PER', controller.special.value.perception),
      ('END', controller.special.value.endurance),
      ('CHA', controller.special.value.charisma),
      ('INT', controller.special.value.intelligence),
      ('AGI', controller.special.value.agility),
      ('LUK', controller.special.value.luck),
    ];

    return stats
        .map((stat) => StatBar(
              label: stat.$1,
              value: stat.$2,
              onIncrement: () => controller.incrementSpecial(stat.$1),
            ))
        .toList();
  }
}

class CharacterInfoCard extends StatelessWidget {
  final Character character;
  final CharacterController characterController;
  final SpecialController controller;

  const CharacterInfoCard({
    Key? key,
    required this.character,
    required this.characterController,
    required this.controller,
  }) : super(key: key);

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
                  _buildInfoItem(
                      'EXP', controller.characterSelect.value.exp.toString()),
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

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
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
                value: value / 255,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
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
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
