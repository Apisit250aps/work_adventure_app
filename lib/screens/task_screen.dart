import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:work_adventure/controllers/tasks_controller.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/models/task_model.dart';
import 'package:work_adventure/widgets/form/forms/task/task_create_form.dart';
import 'package:work_adventure/widgets/sheets/sheet.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final WorkController workController = Get.find<WorkController>();
  final TasksController tasksController = Get.put(TasksController());
  @override
  void initState() {
    super.initState();
    tasksController.loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    print(workController.workSelected);
    final task = tasksController.tasks;
    print(" task >> $task");
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
      ),
      body: RefreshIndicator(
        onRefresh: tasksController.fetchTasks,
        child: Column(
          children: [
            Obx(
              () {
                if (tasksController.isLoading.value) {
                  // แสดง CircularProgressIndicator ขณะโหลดข้อมูล
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (tasksController.tasks.isEmpty) {
                  return const Center(
                    child: Text('No tasks available.'),
                  );
                }
                return Flexible(
                  child: TaskList(tasks: tasksController.tasks),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheetCreateTask(context);
        },
        child: const Icon(Boxicons.bx_message_square_add),
      ),
    );
  }


  void _showBottomSheetCreateTask(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SheetContents(
          children: [
            const SheetHeader(title: "Add task"),
            SheetBody(
              children: [
                TaskCreateForm()
              ],
            )
          ],
        );
      },
    );
  }
}

class TaskList extends StatefulWidget {
  final List<Task> tasks;
  const TaskList({super.key, required this.tasks});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        final task = widget.tasks[index];
        return Card.outlined(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: ListTile(
            title: Text(task.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.description != null) Text(task.description!),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text(task.dueDate != null
                        ? DateFormat('MMM dd, yyyy').format(task.dueDate!)
                        : 'No due date'),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDifficultyChip(task.difficulty),
                const SizedBox(width: 8),
                Icon(
                  task.isDone ? Icons.check_circle : Icons.circle_outlined,
                  color: task.isDone ? Colors.green : Colors.grey,
                ),
              ],
            ),
            onTap: () {
              // Navigate to task details view (implement TaskDetailsPage)
            },
          ),
        );
      },
    );
  }

  Widget _buildDifficultyChip(int difficulty) {
    Color color;
    String label;
    switch (difficulty) {
      case 1:
        color = Colors.green;
        label = 'Easy';
        break;
      case 2:
        color = Colors.orange;
        label = 'Medium';
        break;
      case 3:
        color = Colors.red;
        label = 'Hard';
        break;
      default:
        color = Colors.grey;
        label = 'Unknown';
    }
    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.2),
      labelStyle: TextStyle(color: color),
      side: BorderSide(color: color.withOpacity(0.5)), // Added border color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ), // Optional: adjust border radius
    );
  }
}
