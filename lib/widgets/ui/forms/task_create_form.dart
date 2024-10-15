import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/tasks_controller.dart';
import 'package:work_adventure/widgets/ui/buttons.dart';
import 'package:work_adventure/widgets/ui/forms/inputs.dart';

class TaskCreateForm extends StatefulWidget {
  const TaskCreateForm({super.key});

  @override
  State<TaskCreateForm> createState() => _TaskCreateFormState();
}

class _TaskCreateFormState extends State<TaskCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final TasksController tasksController = Get.find<TasksController>();

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();
  final TextEditingController taskStartController = TextEditingController();
  final TextEditingController taskDueController = TextEditingController();
  final TextEditingController taskDifficultyController =
      TextEditingController(text: "1");
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
                      print('Selected fruit: ${tasksController.status[index]}');
                      taskDifficultyController.text =
                          tasksController.status[index];
                    },
                    isVertical: false,
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    initialSelection: null,
                  )
                ],
              ),
            ),
            GradientButton(
              onPressed: () {
                // Add logic to save the work sheet
                _submitForm();
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      tasksController
          .createTask(
        taskNameController.text,
        taskDescriptionController.text,
        taskStartController.text,
        taskDueController.text,
        int.parse(taskDifficultyController.text),
      )
          .then((success) {
        if (success) {
          Get.back(); // Close the form
          Get.snackbar('Success', 'Task created successfully');
        } else {
          Get.snackbar('Error', 'Failed to create work sheet');
        }
      });
    }
  }
}
