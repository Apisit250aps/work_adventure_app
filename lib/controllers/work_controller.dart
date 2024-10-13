import 'dart:convert';

import 'package:get/get.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/models/character_model.dart';
import 'package:work_adventure/models/work_model.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';

class WorkController extends GetxController {
  final RestServiceController _rest = Get.find();
  final ApiService _apiService = Get.find();
  final CharacterController characterController =
      Get.find<CharacterController>();

  final RxBool isLoading = false.obs;
  List<String> get status => <String>["todo", "inprogress", "done"];
  var selectedStatusIndex = 0.obs;

  final RxList<Work> workList = <Work>[].obs;
  final Rx<Work> workSelected = const Work().obs;

  void updateStatus(int index) {
    selectedStatusIndex.value = index;
  }

  Character get character => characterController.characterSelect.value;
  Work get work => workSelected.value;
  
  @override
  void onInit() {
    super.onInit();
    loadWorks();
  }

  @override
  void onReady() {
    print(workList);
    super.onReady();
  }

  void loadWorks() async {
    isLoading.value = true;
    final result = await fetchAllWork();
    if (result.isNotEmpty) {
      workList.value = result;
    }
    isLoading.value = false;
  }

  void selectIndex(int index) {
    workSelected.value = workList[index];
    print(workSelected);
  }

  Future<List<Work>> fetchAllWork() async {
    try {
      final characterId = character.id;
      isLoading.value = true;
      String path = _rest.work;
      String endpoints = "$path/$characterId";
      print(">> $endpoints");
      final response = await _apiService.get(endpoints);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<Work> workData =
            jsonData.map((data) => Work.fromJson(data)).toList();
        print(workData);
        return workData;
      } else {
        throw Exception("Failed to fetch work: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching work: $e");
      return [];
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> deleteWork(String workId) async {
    try {
      // Set loading state to true
      isLoading.value = true;

      // Construct the endpoint for deletion (assumes _rest.deleteWork holds the base path)
      String path = _rest.deleteWork;
      String endpoint = "$path/$workId";

      // Send DELETE request to the server
      final response = await _apiService.delete(endpoint);

      if (response.statusCode == 200) {
        // Remove the deleted work from the local list
        workList.removeWhere((work) => work.id == workId);
        update(); // This will trigger a UI update (if using GetX state management)
      } else {
        throw Exception("Failed to delete work: ${response.statusCode}");
      }
    } catch (e) {
      print("Error deleting work: $e");
    } finally {
      // Set loading state to false
      isLoading.value = false;
    }
  }

  Future<bool> createWork(
    String name,
    String description,
    String start,
    String due,
    String status,
  ) async {
    final characterId = character.id;
    String path = _rest.createWork;
    String endpoints = "$path/$characterId";
    try {
      final response = await _apiService.post(endpoints, {
        'name': name,
        'description': description,
        'start_date': start,
        'due_date': due,
        'status': status,
      });

      return response.statusCode == 201;
    } catch (e) {
      print("Error creating work: $e");
      return false;
    } finally {
      loadWorks();
      update();
    }
  }
}
