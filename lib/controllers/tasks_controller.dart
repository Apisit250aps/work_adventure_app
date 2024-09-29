import 'package:get/get.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/models/task_model.dart';

class TasksController extends GetxController {
  WorkController workController = Get.find<WorkController>();
  

  RxList<Task> tasks = <Task>[].obs;
}
