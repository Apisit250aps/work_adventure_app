import 'dart:convert';

import 'package:get/get.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/models/task_model.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';

class TasksController extends GetxController {
  final RestServiceController _rest = Get.find();
  final ApiService _apiService = Get.find();
  WorkController workController = Get.find<WorkController>();

  RxList<Task> tasks = <Task>[].obs;
 
  Future<List<Task>> fetchTasks(String workId) async {
    try {
      final String path = _rest.tasks;
      final String endpoint = "$path/$workId";
      final response = await _apiService.get(endpoint);

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        final tasksList = data.map((json) => Task.fromJson(json)).toList();

        tasks.value = tasksList;

        return tasksList;
      } else {
        throw Exception('Failed to fetch tasks: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to fetch tasks: $error');
    }
  }
}
