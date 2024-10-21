import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/tasks_controller.dart';
import 'package:work_adventure/models/task_model.dart';
import 'package:work_adventure/models/work_model.dart';
import 'package:work_adventure/screens/todo/work_screen.dart';
import 'package:work_adventure/widgets/ui/forms/task/task_create_form.dart';
import 'package:work_adventure/widgets/ui/forms/task/task_update_form.dart';
import 'package:work_adventure/widgets/ui/sheets/sheets_ui.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/table_controller.dart';

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
              onPressed: () => workInfoSheets(),
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

  void workInfoSheets() {
    final Work work = controller.onWork;
    Get.bottomSheet(
      BottomSheetContent(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const SheetHeader(title: "Work details"),
              Container(
                margin: const EdgeInsets.only(top: 10),
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
        ),
      ),
    );
  }

  String calculateDifficulty() {
    if (controller.tasks.isEmpty) {
      return "ง่าย"; // ถ้าไม่มี task ให้ถือว่าง่ายที่สุด
    }

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
      onLongPress: () => _showTaskOptions(task),
      title: Text(
        task.name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: task.isDone ? Colors.grey : textColor,
          decoration: task.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle:
          Text(task.description!.isEmpty ? '--' : task.description as String),
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: diffColor(task.difficulty),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          diff(task.difficulty),
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
      // subtitle: Text(task.description ?? ''),
    );
  }

  String diff(int index) {
    List<String> taskDiffs = <String>["Easy", "Medium", "Hard"];
    return taskDiffs[index - 1];
  }

  Color diffColor(int index) {
    List<Color> colors = <Color>[
      Colors.green.shade100,
      Colors.yellow.shade100,
      Colors.red.shade100,
    ];

    return colors[index - 1];
  }

  void _showTaskOptions(Task task) {
    Get.bottomSheet(
      BottomSheetContent(
        child: TaskUpdateForm(
          task: task,
          tasksController: controller,
        ),
      ),
    );
  }

  Widget _buildLeadingIcon() {
    final CharacterController characterController =
        Get.find<CharacterController>();
    final TableController tableController = Get.find<TableController>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            int taskDiff = task.difficulty;
            final (totalExp, totalCoin) = tableController.taskSender(taskDiff);

            String message;
            if (!task.isDone) {
              if (task.isFirst!) {
                characterController.taskAdditional(totalExp, totalCoin);
                message = "เสร็จสิ้นงาน ได้รับ $totalExp🧿 และ $totalCoin💰";
              } else {
                message = "เสร็จสิ้นงาน คุณได้รับ EXP🧿 และ Coin💰";
              }
            } else {
              message = "ยกเลิกงาน โปรดตรวจสอบความเรียบร้อยอีกครั้ง";
            }

            controller.updateTask(task.copyWith(
              isDone: !task.isDone,
              isFirst: task.isFirst! ? false : false,
            ));

            Get.snackbar(
              "สถานะงาน",
              message,
              snackPosition: SnackPosition.TOP,
              duration: const Duration(seconds: 2),
              backgroundColor: task.isDone
                  ? Colors.red.withOpacity(0.7)
                  : Colors.green.withOpacity(0.7),
              colorText: Colors.white,
              borderRadius: 8,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              icon: Icon(
                task.isDone ? Icons.cancel : Icons.check_circle,
                color: Colors.white,
                size: 28,
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: task.isDone ? secondaryColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(milliseconds: 200),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Icon(
                task.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: task.isDone ? Colors.white : textColor,
                size: 28,
              ),
            ),
          ),
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
        onPressed: () => createTaskSheets(),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void createTaskSheets() {
    Get.bottomSheet(const BottomSheetContent(
      child: TaskCreateForm(),
    ));
  }
}
