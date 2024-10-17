import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/quest_controller.dart';

class DailyQuestScreen extends StatelessWidget {
  final QuestController controller = Get.put(QuestController());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textController,
                  decoration: InputDecoration(hintText: 'Enter new quest'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    controller.addQuest(textController.text, '');
                    textController.clear();
                  }
                },
                child: Text('Add'),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(() => ListView.builder(
                itemCount: controller.quests.length,
                itemBuilder: (context, index) {
                  final quest = controller.quests[index];
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
                          icon: Icon(Icons.delete),
                          onPressed: () => controller.deleteQuest(quest.id),
                        ),
                      ],
                    ),
                    onTap: () {
                      // Open edit dialog
                      Get.dialog(
                        AlertDialog(
                          title: Text('Edit Quest'),
                          content: TextField(
                            controller:
                                TextEditingController(text: quest.title),
                            onChanged: (value) => quest.title = value,
                          ),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () => Get.back(),
                            ),
                            TextButton(
                              child: Text('Save'),
                              onPressed: () {
                                controller.updateQuest(quest.id, quest.title,
                                    quest.isCompleted, '');
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              )),
        ),
      ],
    );
  }
}
