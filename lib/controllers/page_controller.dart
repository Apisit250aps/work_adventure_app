
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
}