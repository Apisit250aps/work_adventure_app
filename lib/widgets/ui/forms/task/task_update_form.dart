import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
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
        TextEditingController(text: '${widget.task.difficulty}');
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
                    initialDate: widget.task.dueDate,
                    hintText: 'due',
                    controller: taskDueController,
                  ),
                  CustomSingleSelectToggle(
                    initValue: ["Easy", "Medium", "Hard"][int.parse(taskDifficultyController.text) - 1],
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
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    width: 48, // ปรับขนาดตามต้องการ
                    height: 48, // ปรับขนาดตามต้องการ
                    margin: const EdgeInsets.only(
                        right: 10), // เพิ่มระยะห่างระหว่างปุ่ม
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red, // หรือสีที่คุณต้องการ
                    ),
                    child: IconButton(
                      icon: const Icon(Boxicons.bx_trash, color: Colors.white),
                      onPressed: () {
                        _confirmDelete();
                      },
                    ),
                  ),
                  Expanded(
                    child: GradientButton(
                      onPressed: _submitForm,
                      child: const Text(
                        'Save Work',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedTask = widget.task.copyWith(
        name: taskNameController.text,
        description: taskDescriptionController.text,
        startDate: DateTime.tryParse(taskStartController.text),
        dueDate: DateTime.tryParse(taskDueController.text),
        difficulty: int.tryParse(taskDifficultyController.text) ??
            widget.task.difficulty,
      );

      final success = await widget.tasksController.updateTask(updatedTask);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task updated successfully')),
        );
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update task')),
        );
      }
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content:
              Text('Are you sure you want to delete "${widget.task.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final success = await widget.tasksController
                    .deleteTask(widget.task.id);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task deleted successfully')),
                  );
                  Navigator.of(context).pop(true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to delete task')),
                  );
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
