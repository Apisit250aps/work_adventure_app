import 'dart:convert';

import 'package:get/get.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/models/task_model.dart';
import 'package:work_adventure/models/work_model.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';

class TasksController extends GetxController {
  final RestServiceController _rest = Get.find();
  final ApiService _apiService = Get.find();
  WorkController workController = Get.find<WorkController>();

  final RxBool isLoading = true.obs;

  // form variables
  List<String> get status => <String>["1", "2", "3"];
  var selectedStatusIndex = 0.obs;

  Work get onWork => workController.workSelected.value;

  void updateStatus(int index) {
    selectedStatusIndex.value = index;
  }

  RxList<Task> tasks = <Task>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadTasks();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    isLoading.value = false;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    print("Closed");
  }

  void loadTasks() async {
    try {
      isLoading.value = true;
      tasks.value = await fetchTasks();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  

  Future<List<Task>> fetchTasks() async {
    isLoading.value = true;
    try {
      final workId = workController.workSelected.value.id;
      final String path = _rest.tasks; // Base path for tasks
      final String endpoint = "$path/$workId"; // Constructing the endpoint
      final response = await _apiService.get(endpoint); // Making the API call

      if (response.statusCode == 200) {
        // Decode the response body into a Map
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Access the "task" key from the JSON map and cast it to List<dynamic>
        final List<dynamic> tasksJson = jsonData["tasks"];

        // Map the dynamic objects to Task instances
        final List<Task> tasksList = tasksJson
            .map(
              (json) => Task.fromJson(json),
            )
            .toList();

        // Update the tasks observable variable with the fetched tasks
        tasks.value = tasksList;

        // Print the fetched tasks for debugging
        print(tasksList);

        // Return the list of tasks
        return tasksList;
      } else {
        throw Exception('Failed to fetch tasks: ${response.statusCode}');
      }
    } catch (error) {
      // Log the error for debugging
      print('Error: $error');
      throw Exception('Failed to fetch tasks: $error');
    } finally {
      isLoading.value = false;
    }
  }
}
