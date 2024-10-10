import 'package:get/get.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/page_controller.dart';
import 'package:work_adventure/controllers/work_controller.dart';

class OperatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> PageControllerX());
    Get.put(WorkController());
  }
}

class CharacterBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<CharacterController>();
  }
}