import 'package:get/get.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/characteroutloop_controller.dart';
import 'package:work_adventure/controllers/focus_controller.dart';
import 'package:work_adventure/controllers/page_controller.dart';
import 'package:work_adventure/controllers/special_controller.dart';
import 'package:work_adventure/controllers/table_controller.dart';
import 'package:work_adventure/controllers/tasks_controller.dart';
import 'package:work_adventure/controllers/work_controller.dart';

class OperatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PageControllerX());
    // Get.put(WorkController());
    // Get.put(SpecialController());
    // Get.put(TableController());
    // Get.put(FocusController());
    // Get.put(CharacterbarController());
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

class AuthWarpBinding extends Bindings {
  @override
  void dependencies() {
    // Add bindings for special features here
    // For example:
    Get.find<CharacterController>().loadCharacters();
  }
}

// class SpecialBinding extends Bindings {
//   @override
//   void dependencies() {
//     // Add bindings for special features here
//     // For example:
//     Get.find<>();
//   }
// }