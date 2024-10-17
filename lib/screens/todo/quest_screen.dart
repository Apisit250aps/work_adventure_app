import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/quest_controller.dart';
import 'package:work_adventure/models/hive/quest_hive_model.dart';

class DailyQuestScreen extends GetWidget<QuestController> {
  final TextEditingController textController = TextEditingController();

  DailyQuestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemCount: controller.quests.length,
              itemBuilder: (context, index) {
                final Quest quest = controller.quests[index];
                return ListTile(
                  title: Text(quest.title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: quest.isCompleted,
                        onChanged: (_) =>
                            controller.toggleQuestStatus(quest.id),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => controller.deleteQuest(quest.id),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Open edit dialog
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Edit Quest'),
                        content: TextField(
                          controller: TextEditingController(text: quest.title),
                          onChanged: (value) => quest.title = value,
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Get.back(),
                          ),
                          TextButton(
                            child: const Text('Save'),
                            onPressed: () {
                              controller.updateQuest(
                                  quest.id, quest.title, quest.isCompleted, '');
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
