import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
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
        child: Icon(Boxicons.bx_message_square_add),
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
            SheetHeader(title: "Add task"),
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
          color: Colors.white,
          margin: const EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          child: ListTile(
            title: Text(task.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.description != null)
                  Text(
                    task.description!,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                if (task.startDate != null)
                  Text('Start Date: ${task.startDate!.toLocal()}'),
                if (task.dueDate != null)
                  Text('Due Date: ${task.dueDate!.toLocal()}'),
                Text('Difficulty: ${task.difficulty}'),
                Text('Status: ${task.isDone == true ? "Done" : "Not Done"}'),
              ],
            ),
            trailing: Icon(
              task.isDone == true
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.isDone == true ? Colors.green : Colors.red,
            ),
            onTap: () {
              // Handle tap event (e.g., navigate to detail page)
            },
          ),
        );
      },
    );
  }
}
