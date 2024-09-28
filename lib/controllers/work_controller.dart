import 'package:get/get.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/models/work_model.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';

class WorkController extends GetxController {
  final RestServiceController _rest = Get.find();
  final ApiService _apiService = Get.find();
  CharacterController characterController = Get.find();
  var works = <Work>[].obs;
  late final String characterId;

  // List<String> get status => ["todo", "inprogress", "done"];

  var status = <String>["Pending", "In Progress", "Completed"].obs;
  var selectedStatusIndex = 0.obs; // ใช้เพื่อเก็บดัชนีของตัวเลือกที่เลือก

  // ฟังก์ชันเพื่ออัปเดตสถานะ
  void updateStatus(int index) {
    selectedStatusIndex.value = index; // อัปเดตดัชนี
  }

  @override
  void onInit() {
    super.onInit();
    characterId = characterController.character.id;
  }

  Future<void> createWork(
    String name,
    String description,
    String start,
    String due,
    String status,
  ) async {
    String path = _rest.createWork;
    String endpoints = "$path/$characterId";

    final response = await _apiService.post(endpoints, {
      'name': name,
      'description': description,
      'start': start,
      'due': due,
      'status': status,
    });
  }
}
