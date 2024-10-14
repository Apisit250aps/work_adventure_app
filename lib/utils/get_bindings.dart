import 'package:get/get.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/focus_controller.dart';
import 'package:work_adventure/controllers/page_controller.dart';
import 'package:work_adventure/controllers/tasks_controller.dart';
import 'package:work_adventure/controllers/work_controller.dart';

class OperatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PageControllerX());
    Get.put(WorkController());
    Get.put(FocusController());
  }
}

class CharacterBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<CharacterController>();
  }
}

class TaskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TasksController());
  }
}
