
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageControllerX extends GetxController {
  var pageIndex = 0.obs;
  PageController pageController = PageController();

  

  void changePage(int index) {
    pageIndex.value = index;
    pageController.jumpToPage(index);
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  Future<bool> showExitConfirmationDialog() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirm Exit'),
        content: const Text('Do you want to go back to character?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Get.back(result: false),
          ),
          TextButton(
            child: const Text('Confirm'),
            onPressed: () => Get.back(result: true),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}