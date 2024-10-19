import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/characteroutloop_controller.dart';
import 'package:work_adventure/controllers/focus_controller.dart';
import 'package:work_adventure/controllers/quest_controller.dart';
import 'package:work_adventure/controllers/special_controller.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/controllers/table_controller.dart';
// import 'package:work_adventure/controllers/characterbar_controller.dart';

class PageControllerX extends GetxController {
  final pageIndex = 0.obs;
  late final PageController pageController;

  late final WorkController workController;
  late final QuestController questController;
  late final SpecialController specialController;
  late final FocusController focusController;
  late final TableController tableController;
  late final CharacterbarController characterbarController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
    workController = Get.put(WorkController());
    questController = Get.put(QuestController());
    specialController = Get.put(SpecialController());
    tableController = Get.put(TableController());
    focusController = Get.put(FocusController());
    characterbarController = Get.put(CharacterbarController());
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