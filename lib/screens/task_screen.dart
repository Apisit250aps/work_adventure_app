import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/tasks_controller.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/models/task_model.dart';

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
    );
  }
}

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  TaskList({required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
