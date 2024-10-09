import 'package:get/get.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/page_controller.dart';

class OperatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PageControllerX());
  }
}

class CharacterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CharacterController());
  }
}
