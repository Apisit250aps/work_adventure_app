import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/tasks_controller.dart';
import 'package:work_adventure/models/task_model.dart';
import 'package:work_adventure/widgets/ui/forms/task_create_form.dart';
import 'package:work_adventure/widgets/ui/sheets/sheets_ui.dart';

class TaskScreen extends GetWidget<TasksController> {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent, // เพิ่มบรรทัดนี้
          surfaceTintColor: Colors.transparent, // เพิ่มบรรทัดนี้
          elevation: 0,
          scrolledUnderElevation: 0,
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

          bottom: const TabBar(
            indicator: BoxDecoration(), // ลบเส้นใต้
            indicatorColor: Colors.transparent, // หรือใช้ null
            labelColor: Colors.black, // ปรับสีข้อความแท็บ
            unselectedLabelColor: Colors.grey, // สีข้อความแท็บที่ไม่ได้เลือก
            tabs: [
              Tab(
                icon: Text(
                  "To do",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Tab(
                icon: Text(
                  "Done",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList(() => controller.todoTasks),
            _buildTaskList(() => controller.doneTasks),
          ],
        ),
        floatingActionButton: const TaskFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildTaskList(List<Task> Function() taskSelector) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final tasks = taskSelector();
      return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) => TaskListTile(tasks[index]),
      );
    });
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

class TaskListTile extends GetWidget<TasksController> {
  final Task task;
  const TaskListTile(this.task, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildLeadingIcon(),
      title: Text(
        task.name,
        style: TextStyle(
          decoration: task.isDone ? TextDecoration.lineThrough : null,
          color: task.isDone ? Colors.grey : textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(controller.diffs(task.difficulty)),
    );
  }

  Widget _buildLeadingIcon() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 10),
              blurRadius: 50)
        ],
      ),
      child: IconButton(
        icon: Icon(Boxicons.bx_check,
            color: task.isDone ? Colors.white : textColor),
        onPressed: () =>
            controller.updateTask(task.copyWith(isDone: !task.isDone)),
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
              task.isDone ? secondaryColor : Colors.white),
          elevation: const WidgetStatePropertyAll(5),
        ),
      ),
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
