import 'dart:convert';

import 'package:get/get.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/models/work_model.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';

class WorkController extends GetxController {
  final RestServiceController _rest = Get.find();
  final ApiService _apiService = Get.find();
  CharacterController characterController = Get.find();

  late final String characterId;

  final RxBool isLoading = false.obs;
  final RxList<Work> allWork = <Work>[].obs;

  var status = <String>["todo", "inprogress", "done"].obs;
  var selectedStatusIndex = 0.obs;

  final Rx<Work?> selected = Rx<Work?>(null);

  void updateStatus(int index) {
    selectedStatusIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    characterId = characterController.character.id;
    loadWorks();
  }

  void selectWork(Work work) {
    selected.value = work;
  }

  void loadWorks() async {
    isLoading.value = true; // เริ่มการโหลด
    final result = await fetchAllWork();
    if (result.isNotEmpty) {
      allWork.value = result;
    } else {
      Get.snackbar("Error", "No works found or an error occurred.");
    }
    isLoading.value = false; // หยุดการโหลด
  }

  Future<List<Work>> fetchAllWork() async {
    try {
      String path = _rest.allWork;
      String endpoints = "$path/$characterId";
      final response = await _apiService.get(endpoints);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<Work> workList =
            jsonData.map((data) => Work.fromJson(data)).toList();
        allWork.value = workList;
        return workList;
      } else {
        throw Exception("Failed to fetch work: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching work: $e");
      return [];
    }
  }

  Future<bool> createWork(
    String name,
    String description,
    String start,
    String due,
    String status,
  ) async {
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
    }
  }
}
