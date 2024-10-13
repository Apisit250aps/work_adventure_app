import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/tasks_controller.dart';

class TaskScreen extends GetWidget<TasksController> {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Obx(
          () => Text(
            controller.onWork.name as String,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(baseColor),
              elevation: const WidgetStatePropertyAll(5),
              iconSize: const WidgetStatePropertyAll(28),
            ),
            icon: const Icon(Boxicons.bx_detail),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
