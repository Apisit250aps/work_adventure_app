
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/main.dart';
import 'package:work_adventure/models/character_model.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final int index;

  const CharacterCard(
      {super.key, required this.character, required this.index});

  @override
  Widget build(BuildContext context) {
    final CharacterController characterController = Get.find();
    return GestureDetector(
      onTap: () {
        characterController.selectIndex(index);
        Get.to(() => const OperatorScreen());
      },
      child: Card.outlined(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        child: Container(
          width: 250,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(Icons.person, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    character.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                character.className,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              _buildInfoRow(Icons.star, 'Level', character.level.toString()),
              _buildInfoRow(Icons.flash_on, 'EXP', character.exp.toString()),
              _buildInfoRow(
                  Icons.favorite, 'Health', character.health.toString()),
              _buildInfoRow(
                  Icons.bolt, 'Stamina', character.stamina.toString()),
              _buildInfoRow(
                  Icons.monetization_on, 'Coins', character.coin.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}