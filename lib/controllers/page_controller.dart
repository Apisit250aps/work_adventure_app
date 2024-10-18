import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/widgets/ui/dialog/custom_confirm_dialog.dart';

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
      CustomConfirmDialog(
        title: 'Are you sure to delete?',
        onConfirm: () => Get.back(result: true),
        icon: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red.withOpacity(0.1),
          ),
          child: Icon(
            Icons.delete_outline,
            color: Colors.red[300],
            size: 30,
          ),
        ),
      ),
    );
    return result ?? false;
  }
}
