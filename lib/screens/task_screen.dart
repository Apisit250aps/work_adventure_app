import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/work_controller.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  WorkController workController = Get.find<WorkController>();
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
        appBar: AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: const Text(
        "Tasks",
        style: TextStyle(
          color: Colors.black,
          fontSize: 36,
          fontWeight: FontWeight.w600,
        ),
      ),
    ));
  }
}
