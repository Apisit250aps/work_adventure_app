import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/quest_controller.dart';
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
            child: Container(
              margin: const EdgeInsets.only(bottom: 3),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  IconButton(
                    style: ButtonStyle(
                      iconColor: WidgetStatePropertyAll(
                          !quest.isCompleted ? textColor : baseColor),
                      backgroundColor: WidgetStatePropertyAll(
                          quest.isCompleted ? secondaryColor : baseColor),
                    ),
                    iconSize: 24,
                    onPressed: () => controller.toggleQuestStatus(quest),
                    icon: const Icon(Boxicons.bx_check),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quest.title,
                          style: TextStyle(
                            color: quest.isCompleted?Colors.grey:textColor,
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
}
