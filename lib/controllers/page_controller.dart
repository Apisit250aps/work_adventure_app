import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/characteroutloop_controller.dart';
import 'package:work_adventure/controllers/focus_controller.dart';
import 'package:work_adventure/controllers/quest_controller.dart';
import 'package:work_adventure/controllers/special_controller.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/controllers/table_controller.dart';
import 'package:work_adventure/controllers/tasks_controller.dart';

// import 'package:work_adventure/controllers/characterbar_controller.dart';

class PageControllerX extends GetxController {
  final pageIndex = 0.obs;
  late PageController pageController;
  final WorkController workController;
  final QuestController questController;
  final SpecialController specialController;
  final FocusController focusController;
  final TableController tableController;
  final CharacterbarController characterbarController;
  final TasksController tasksController;

  PageControllerX()
      : workController = Get.put(WorkController()),
        tasksController = Get.put(TasksController()),
        specialController = Get.put(SpecialController()),
        tableController = Get.put(TableController()),
        focusController = Get.put(FocusController()),
        characterbarController = Get.put(CharacterbarController()),
        questController = Get.put(QuestController());

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void changePage(int index) {
    pageIndex.value = index;
    refreshScreenChange();
    pageController.jumpToPage(index);
  }

  void refreshScreenChange() {
    switch (pageIndex.value) {
      case 0:
        workController.refreshWorks();
        break;
      case 1:
        questController.loadQuests();
        break;
      case 2:
        // เพิ่มการรีเฟรชหน้าที่ 3 ถ้าจำเป็น
        break;
      case 3:
        specialController.specialRefresh();
        break;
    }
  }
}
