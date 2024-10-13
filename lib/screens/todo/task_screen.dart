import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/tasks_controller.dart';
import 'package:work_adventure/widgets/ui/forms/task_create_form.dart';
import 'package:work_adventure/widgets/ui/sheets/sheets_ui.dart';

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
            icon: const Icon(Boxicons.bx_calendar),
            onPressed: () => workInfoSheets(context),
          ),
        ],
      ),
      floatingActionButton: const TaskFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void workInfoSheets(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.75,
          expand: false,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.only(top: 10),
              child: const Column(
                children: [
                  SheetHeader(title: "Details"),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class TaskFloatingActionButton extends StatelessWidget {
  const TaskFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            secondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: FloatingActionButton(
        onPressed: () => createTaskSheets(context),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void createTaskSheets(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.75,
          expand: false,
          builder: (_, controller) {
            return const TaskCreateForm();
          },
        );
      },
    );
  }
}

