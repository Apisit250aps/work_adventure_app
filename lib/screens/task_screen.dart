import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:work_adventure/controllers/tasks_controller.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/models/task_model.dart';
import 'package:work_adventure/widgets/button/form_button.dart';
import 'package:work_adventure/widgets/form/inputs/datepicker_label.dart';
import 'package:work_adventure/widgets/form/inputs/input_label.dart';
import 'package:work_adventure/widgets/sheets/sheet.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  WorkController workController = Get.find<WorkController>();
  TasksController tasksController = Get.find<TasksController>();
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
      ),
      body: TaskList(tasks: tasksController.tasks),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheetCreateTask(context);
        },
        child: const Icon(Boxicons.bx_message_square_add),
      ),
    );
  }

  final TextEditingController _difficulty = TextEditingController(text: "1");
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _start = TextEditingController();
  final TextEditingController _due = TextEditingController();

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
                InputLabel(
                  label: "name",
                  controller: _name,
                ),
                InputLabel(
                  label: "description",
                  controller: _description,
                ),
                DateInputLabel(
                  label: 'Start Date',
                  onDateSelected: (DateTime date) {
                    _start.text = date.toString();
                    print(_start.text);
                  },
                ),
                DateInputLabel(
                  label: 'Due Date',
                  onDateSelected: (DateTime date) {
                    _due.text = date.toString();
                  },
                ),
                Obx(
                  () => Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: ToggleButtons(
                      direction: Axis.horizontal,
                      onPressed: (int index) {
                        tasksController.updateStatus(index);
                        setState(() {
                          _difficulty.text = tasksController.status[
                              tasksController.selectedStatusIndex.value];
                          print(_difficulty.text);
                        });
                      },
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: Colors.black,
                      selectedColor: Colors.white,
                      fillColor: Colors.black,
                      color: Colors.black,
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                        minWidth: 80.0,
                      ),
                      isSelected: List.generate(
                          tasksController.status.length,
                          (i) =>
                              i == tasksController.selectedStatusIndex.value),
                      children: ["easy", "medium", "hard"].map((status) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: Text(status),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SquareButton(
                  onClick: () {},
                  isLoading: false,
                  buttonText: "Create",
                )
              ],
            )
          ],
        );
      },
    );
  }
}

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
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
