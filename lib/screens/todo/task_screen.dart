import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/tasks_controller.dart';
import 'package:work_adventure/models/task_model.dart';
import 'package:work_adventure/models/work_model.dart';
import 'package:work_adventure/widgets/ui/forms/task/task_create_form.dart';
import 'package:work_adventure/widgets/ui/forms/task/task_update_form.dart';
import 'package:work_adventure/widgets/ui/sheets/sheets_ui.dart';

enum Difficulty { easy, medium, hard }

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
            _buildTaskList(false),
            _buildTaskList(true),
          ],
        ),
        floatingActionButton: const TaskFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildTaskList(bool isDone) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final tasks =
          controller.tasks.where((task) => task.isDone == isDone).toList();
      return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskListTile(tasks[index]);
        },
      );
    });
  }

  void workInfoSheets(BuildContext context) {
    final Work work = controller.onWork;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.75,
          expand: false,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const SheetHeader(title: "Work details"),
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        // color: baseColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          const Icon(
                            Boxicons.bx_receipt,
                            color: Colors.black,
                            size: 36,
                          ),
                          'Work',
                          work.name as String,
                        ),
                        _buildInfoRow(
                          const Icon(
                            Boxicons.bx_notepad,
                            color: Colors.pink,
                            size: 36,
                          ),
                          'Description',
                          work.description ?? '--',
                        ),
                        _buildInfoRow(
                          Icon(
                            Boxicons.bx_calendar_check,
                            color: Colors.green[600],
                            size: 36,
                          ),
                          'Start Date',
                          work.startDate.toString(),
                        ),
                        _buildInfoRow(
                          Icon(
                            Boxicons.bx_calendar_x,
                            color: Colors.red[600],
                            size: 36,
                          ),
                          'Due Date',
                          work.dueDate.toString(),
                        ),
                        _buildInfoRow(
                          Icon(
                            Boxicons.bx_stats,
                            color: Colors.blue[600],
                            size: 36,
                          ),
                          'Status',
                          work.status.toString(),
                        ),
                        _buildInfoRow(
                          Icon(
                            Boxicons.bx_meteor,
                            color: Colors.blue[600],
                            size: 36,
                          ),
                          'Difficulty',
                          calculateDifficulty(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  String calculateDifficulty() {
    if (controller.tasks.isEmpty)
      return "ง่าย"; // ถ้าไม่มี task ให้ถือว่าง่ายที่สุด

    double averageDifficulty = controller.tasks
            .map((task) => task.difficulty)
            .reduce((a, b) => a + b) /
        controller.tasks.length;

    if (averageDifficulty < 1.5) return "ง่าย";
    if (averageDifficulty < 2.5) return "กลาง";
    return "ยาก";
  }

  int _difficultyToNumber(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 1;
      case Difficulty.medium:
        return 2;
      case Difficulty.hard:
        return 3;
    }
  }

  Widget _buildInfoRow(Icon icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  offset: Offset(0, 10), // corresponds to 0px 10px
                  blurRadius: 5, // corresponds to 50px
                )
              ],
            ),
            child: icon,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[400])),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaskListTile extends GetWidget<TasksController> {
  final Task task;
  const TaskListTile(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildLeadingIcon(),
      onLongPress: () => _showTaskOptions(context, task),
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

  void _showTaskOptions(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.75,
          expand: false,
          builder: (_, controllers) {
            return TaskUpdateForm(
              task: task,
              tasksController: controller,
            );
          },
        );
      },
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
        onPressed: () {
          controller.updateTask(task.copyWith(
              isDone: !task.isDone, isFirst: task.isFirst! ? false : false));
        },
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
