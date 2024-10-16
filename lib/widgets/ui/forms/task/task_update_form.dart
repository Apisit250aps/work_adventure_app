import 'package:flutter/material.dart';
import 'package:work_adventure/controllers/tasks_controller.dart';
import 'package:work_adventure/models/task_model.dart';
import 'package:work_adventure/widgets/ui/buttons.dart';
import 'package:work_adventure/widgets/ui/forms/inputs.dart';

class TaskUpdateForm extends StatefulWidget {
  final Task task;
  final TasksController tasksController;
  const TaskUpdateForm({
    super.key,
    required this.task,
    required this.tasksController,
  });

  @override
  State<TaskUpdateForm> createState() => _TaskUpdateFormState();
}

class _TaskUpdateFormState extends State<TaskUpdateForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController taskNameController;
  late TextEditingController taskDescriptionController;
  late TextEditingController taskStartController;
  late TextEditingController taskDueController;
  late TextEditingController taskDifficultyController;

  @override
  void initState() {
    super.initState();
    taskNameController = TextEditingController(text: widget.task.name ?? '');
    taskDescriptionController =
        TextEditingController(text: widget.task.description ?? '');
    taskStartController =
        TextEditingController(text: widget.task.startDate?.toString() ?? '');
    taskDueController =
        TextEditingController(text: widget.task.dueDate?.toString() ?? '');
    taskDifficultyController =
        TextEditingController(text: widget.task.difficulty as String);
  }

  @override
  void dispose() {
    taskNameController.dispose();
    taskDescriptionController.dispose();
    taskStartController.dispose();
    taskDueController.dispose();
    taskDifficultyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            const Text(
              'Create Task',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    offset: Offset(0, 10), // corresponds to 0px 10px
                    blurRadius: 50, // corresponds to 50px
                  )
                ],
              ),
              child: Column(
                children: [
                  CustomTextField(
                    hintText: "name",
                    controller: taskNameController,
                  ),
                  CustomTextField(
                    hintText: "description",
                    controller: taskDescriptionController,
                  ),
                  CustomDatePickerField(
                    hintText: 'start',
                    controller: taskStartController,
                  ),
                  CustomDatePickerField(
                    hintText: 'due',
                    controller: taskDueController,
                  ),
                  CustomSingleSelectToggle(
                    options: const ["Easy", "Medium", "Hard"],
                    onSelected: (index) {
                      print(
                          'Selected fruit: ${widget.tasksController.status[index]}');
                      taskDifficultyController.text =
                          widget.tasksController.status[index];
                    },
                    isVertical: false,
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    // initialSelection: null,
                  )
                ],
              ),
            ),
            GradientButton(
              onPressed: () {
                // Add logic to save the work sheet
              },
              child: const Text(
                'Save Task',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
