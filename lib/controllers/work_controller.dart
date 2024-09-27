import 'package:get/get.dart';
import 'package:work_adventure/models/work_model.dart';

class WorkController extends GetxController {
  var works = <Work>[].obs;

  Future<void> createWork(
    String name,
    String description,
    String start,
    String due,
    String status,
  ) async {
    
  }
}
