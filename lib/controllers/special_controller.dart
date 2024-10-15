import 'dart:convert';

import 'package:get/get.dart';
import 'package:work_adventure/controllers/character_controller.dart';

import 'package:work_adventure/models/character_model.dart';
import 'package:work_adventure/models/spacial_model.dart';
import 'package:work_adventure/services/api_service.dart';
import 'package:work_adventure/services/rest_service.dart';

class SpecialController extends GetxController {
  final RestServiceController _rest = Get.find();
  final ApiService _apiService = Get.find();
  final CharacterController characterController =
      Get.find<CharacterController>();

  Character get character => characterController.characterSelect.value;
  Rx<Special> special = Special(
    strength: 0,
    perception: 0,
    endurance: 0,
    charisma: 0,
    intelligence: 0,
    agility: 0,
    luck: 0,
    id: '',
    charId: '',
  ).obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadSpecial();
  }

  Future<void> loadSpecial() async {
    isLoading.value = true;

    try {
      final specialData = await fetchSpecialCharacter();
      if (specialData != null) {
        special.value = specialData;
      } else {
        print("No special data found for this character");
      }
    } catch (e) {
      print("Error fetching special data: $e");
    } finally {
      isLoading.value = false;
      print(special);
    }
  }

  Future<Special?> fetchSpecialCharacter() async {
    final characterId = character.id;
    isLoading.value = true;

    try {
      String path = _rest.charSpecials;
      String endpoints = "$path/$characterId";
      print(">> $endpoints");

      final response = await _apiService.get(endpoints);

      if (response.statusCode == 200) {
        final Map<String, dynamic> specialData = json.decode(response.body);

        if (specialData.isNotEmpty) {
          return Special.fromJson(specialData);
        } else {
          print("No special data found for this character");
          return null;
        }
      } else {
        print(
            "Failed to fetch special data. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching special data: $e");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  void incrementSpecial(String status) {
    Special updatedSpecial = special.value.copyWith();
    switch (status) {
      case "STR":
        updatedSpecial =
            updatedSpecial.copyWith(strength: updatedSpecial.strength + 1);
        break;
      case "PER":
        updatedSpecial =
            updatedSpecial.copyWith(perception: updatedSpecial.perception + 1);
        break;
      case "END":
        updatedSpecial =
            updatedSpecial.copyWith(endurance: updatedSpecial.endurance + 1);
        break;
      case "CHA":
        updatedSpecial =
            updatedSpecial.copyWith(charisma: updatedSpecial.charisma + 1);
        break;
      case "INT":
        updatedSpecial = updatedSpecial.copyWith(
            intelligence: updatedSpecial.intelligence + 1);
        break;
      case "AGI":
        updatedSpecial =
            updatedSpecial.copyWith(agility: updatedSpecial.agility + 1);
        break;
      case "LUK":
        updatedSpecial = updatedSpecial.copyWith(luck: updatedSpecial.luck + 1);
        break;
    }

    special.value = updatedSpecial;
    print("Incremented $status: ${special.value.toJson()}");
    updateSpecialOnServer();
  }

  void decrementSpecial(String status) {
    Special updatedSpecial = special.value.copyWith();

    switch (status) {
      case "STR":
        if (updatedSpecial.strength > 0) {
          updatedSpecial =
              updatedSpecial.copyWith(strength: updatedSpecial.strength - 1);
        }
        break;
      case "PER":
        if (updatedSpecial.perception > 0) {
          updatedSpecial = updatedSpecial.copyWith(
              perception: updatedSpecial.perception - 1);
        }
        break;
      case "END":
        if (updatedSpecial.endurance > 0) {
          updatedSpecial =
              updatedSpecial.copyWith(endurance: updatedSpecial.endurance - 1);
        }
        break;
      case "CHA":
        if (updatedSpecial.charisma > 0) {
          updatedSpecial =
              updatedSpecial.copyWith(charisma: updatedSpecial.charisma - 1);
        }
        break;
      case "INT":
        if (updatedSpecial.intelligence > 0) {
          updatedSpecial = updatedSpecial.copyWith(
              intelligence: updatedSpecial.intelligence - 1);
        }
        break;
      case "AGI":
        if (updatedSpecial.agility > 0) {
          updatedSpecial =
              updatedSpecial.copyWith(agility: updatedSpecial.agility - 1);
        }
        break;
      case "LUK":
        if (updatedSpecial.luck > 0) {
          updatedSpecial =
              updatedSpecial.copyWith(luck: updatedSpecial.luck - 1);
        }
        break;
    }

    special.value = updatedSpecial;
    print("Decremented $status: ${special.value.toJson()}");
    updateSpecialOnServer();
  }

  Future<void> updateSpecialOnServer() async {
    try {
      String path = _rest.updateSpecial;
      String endpoints = "$path/${special.value.id}";
      print(special.value.toJson());
      final response = await _apiService.put(
        endpoints,
        special.value.toJson(),
      );

      if (response.statusCode == 200) {
        print("Special updated successfully on server");
      } else {
        print(
            "Failed to update special on server. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error updating special on server: $e");
      // You might want to show an error message to the user here
    }
  }
}
