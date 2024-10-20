import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/quest_controller.dart';
import 'package:work_adventure/controllers/table_controller.dart';
import 'package:work_adventure/models/hive/quest_hive_model.dart';
import 'package:work_adventure/widgets/ui/loading/slime_loading.dart';

class DailyQuestScreen extends GetWidget<QuestController> {
  final TextEditingController textController = TextEditingController();

  DailyQuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(
            () {
              if (controller.isLoading.value) {
                return const Center(
                  child: SlimeLoading(),
                );
              } else if (controller.quests.isEmpty) {
                return const Center(
                  child: Text('No quests available'),
                );
              } else {
                return ListView.builder(
                  itemCount: controller.quests.length,
                  itemBuilder: (context, index) {
                    final Quest quest = controller.quests[index];
                    return QuestTileList(quest);
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

class QuestTileList extends GetWidget<QuestController> {
  final Quest quest;
  const QuestTileList(this.quest, {super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.isLoading.value) {
          return Container();
        } else {
          return GestureDetector(
            onTap: () => _handleQuestStatusToggle(),
            child: Container(
              margin: const EdgeInsets.only(bottom: 3),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildLeadingIcon(),
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quest.title,
                          style: TextStyle(
                            color: quest.isCompleted ? Colors.grey : textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decoration: quest.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        Text(
                          quest.details,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildLeadingIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 200),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: IconButton(
        style: ButtonStyle(
          iconColor: WidgetStatePropertyAll(
              !quest.isCompleted ? textColor : baseColor),
          backgroundColor: WidgetStatePropertyAll(
              quest.isCompleted ? secondaryColor : baseColor),
        ),
        iconSize: 24,
        onPressed: () => _handleQuestStatusToggle(),
        icon: const Icon(Boxicons.bx_check),
      ),
    );
  }

  void _handleQuestStatusToggle() {
    final TableController tableController = Get.find<TableController>();

    final (totalExp, totalCoin) = tableController.questSender();

    String message = "งานสำเร็จ! ได้รับ $totalExp🧿 และ $totalCoin💰";
    if (!quest.isCompleted) {
      Get.snackbar(
        "สถานะงาน",
        message,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        backgroundColor: quest.isCompleted
            ? Colors.green.withOpacity(0.7)
            : Colors.green.withOpacity(0.7),
        colorText: Colors.white,
        borderRadius: 8,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        icon: Icon(
          quest.isCompleted ? Icons.cancel : Icons.check_circle,
          color: Colors.white,
          size: 28,
        ),
      );
    }
    controller.toggleQuestStatus(quest);
  }
}
