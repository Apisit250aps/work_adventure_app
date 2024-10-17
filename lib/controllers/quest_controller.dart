import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:work_adventure/models/hive/quest_hive_model.dart';

class QuestController extends GetxController {
  late Box<Quest> _questBox;
  final quests = <Quest>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await Hive.initFlutter();
    Hive.registerAdapter(QuestAdapter());
    _questBox = await Hive.openBox<Quest>('quests');
    loadQuests();
  }

  void loadQuests() {
    final today = DateTime.now();
    quests.value = _questBox.values
        .where((quest) =>
            quest.date.year == today.year &&
            quest.date.month == today.month &&
            quest.date.day == today.day)
        .toList();

    if (quests.isEmpty) {
      createDefaultQuests();
    }
  }

  void createDefaultQuests() {
    final defaultQuests = [
      Quest(
        title: 'ออกกำลังกาย',
        date: DateTime.now(),
        details: 'วิ่งเป็นเวลา 30 นาที',
      ),
      Quest(
        title: 'อ่านหนังสือ',
        date: DateTime.now(),
        details: 'อ่านหนังสือเป็นเวลา 1 ชั่วโมง',
      ),
      Quest(
        title: 'เรียนภาษาใหม่',
        date: DateTime.now(),
        details: 'ฝึกภาษาอังกฤษ 30 นาที',
      ),
    ];

    for (var quest in defaultQuests) {
      _questBox.add(quest);
    }

    loadQuests();
  }

  Future<void> addQuest(String title, String details) async {
    final newQuest = Quest(
      title: title,
      date: DateTime.now(),
      details: details,
    );
    await _questBox.add(newQuest);
    loadQuests();
  }

  Future<void> updateQuest(String id, String title, bool isCompleted, String details) async {
    final questToUpdate = _questBox.values.firstWhere((quest) => quest.id == id);
    questToUpdate.title = title;
    questToUpdate.isCompleted = isCompleted;
    questToUpdate.details = details;
    await questToUpdate.save();
    loadQuests();
  }

  Future<void> deleteQuest(String id) async {
    final questToDelete = _questBox.values.firstWhere((quest) => quest.id == id);
    await questToDelete.delete();
    loadQuests();
  }

  Future<void> toggleQuestStatus(String id) async {
    final quest = _questBox.values.firstWhere((quest) => quest.id == id);
    quest.isCompleted = !quest.isCompleted;
    await quest.save();
    loadQuests();
  }
}