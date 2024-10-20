import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:work_adventure/models/hive/quest_hive_model.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/table_controller.dart';

class QuestController extends GetxController {
  late Box<Quest> _questBox;
  final quests = <Quest>[].obs;
  RxBool isLoading = true.obs;

  final CharacterController _characterController =
      Get.find<CharacterController>();
  final TableController _tableController = Get.find<TableController>();

  @override
  void onInit() async {
    super.onInit();

    _questBox = await Hive.openBox<Quest>('quests');
    loadQuests();
  }

  void loadQuests() {
    isLoading.value = true;
    try {
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
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void createDefaultQuests() {
    final defaultQuests = [
      Quest(
        title: 'พักสายตา',
        date: DateTime.now(),
        details: 'หลับตาพักสายตาจากหน้าจอเป็นเวลา 10 นาทีทุกชั่วโมง',
      ),
      Quest(
        title: 'ยืดเส้นยืดสาย',
        date: DateTime.now(),
        details: 'ลุกขึ้นยืนและยืดเส้นยืดสายทุก 2 ชั่วโมง ทำท่าโยคะเบาๆ 5 นาที',
      ),
      Quest(
        title: 'ดื่มน้ำให้เพียงพอ',
        date: DateTime.now(),
        details: 'ดื่มน้ำให้ครบ 8 แก้วในระหว่างวัน และพักดื่มน้ำทุกชั่วโมง',
      ),
      Quest(
        title: 'นั่งสมาธิ',
        date: DateTime.now(),
        details:
            'นั่งสมาธิหรือลองทำการฝึกหายใจลึกๆ เป็นเวลา 10 นาที เพื่อผ่อนคลาย',
      ),
      Quest(
        title: 'เดินเล่นพักสมอง',
        date: DateTime.now(),
        details:
            'ออกจากโต๊ะทำงานแล้วไปเดินเล่นนอกบ้าน หรือเดินไปรอบๆ ออฟฟิศ 10 นาที',
      ),
      Quest(
        title: 'ฟังเพลงผ่อนคลาย',
        date: DateTime.now(),
        details: 'ฟังเพลงที่ชอบเพื่อผ่อนคลายจิตใจระหว่างพักช่วงจากการทำงาน',
      ),
      Quest(
        title: 'งีบสั้นๆ',
        date: DateTime.now(),
        details: 'งีบหลับสั้นๆ 15-20 นาทีในช่วงบ่ายเพื่อเติมพลัง',
      ),
      Quest(
        title: 'ออกไปรับแสงแดด',
        date: DateTime.now(),
        details:
            'ออกไปรับแสงแดดและสูดอากาศบริสุทธิ์เป็นเวลา 10 นาทีในช่วงพักกลางวัน',
      ),
    ];
    for (var quest in defaultQuests) {
      _questBox.add(quest);
    }
    loadQuests();
  }

  Future<bool> addQuest(String title, String details) async {
    try {
      final newQuest = Quest(
        title: title,
        date: DateTime.now(),
        details: details,
      );

      await _questBox.add(newQuest);
      return true;
    } catch (e) {
      print('Error adding quest: $e');
      return false;
    } finally {
      loadQuests();
    }
  }

  Future<void> updateQuest(
      String id, String title, bool isCompleted, String details) async {
    final questToUpdate =
        _questBox.values.firstWhere((quest) => quest.id == id);
    questToUpdate.title = title;
    questToUpdate.isCompleted = isCompleted;
    questToUpdate.details = details;
    await questToUpdate.save();
    loadQuests();
  }

  Future<void> deleteQuest(String id) async {
    final questToDelete =
        _questBox.values.firstWhere((quest) => quest.id == id);
    await questToDelete.delete();
    loadQuests();
  }

  Future<void> toggleQuestStatus(
      Quest quest, int totalExp, int totalCoin) async {
    isLoading.value = true;
    print('Toggling status for quest: ${quest.id}');

    try {
      if (!quest.isCompleted) {
        final storedQuest =
            _questBox.values.firstWhere((q) => q.id == quest.id);
        storedQuest.isCompleted = !storedQuest.isCompleted;
        await storedQuest.save();
        _characterController.taskAdditional(totalExp, totalCoin);
        print('EXP :$totalExp Coin:$totalCoin completed');
        print('Quest status toggled successfully');
      }
    } catch (e) {
      print('Error toggling quest status: $e');
      // Optionally, you might want to rethrow the error or handle it differently
    }
    quests.refresh();
    loadQuests();
    update();
  }
}
