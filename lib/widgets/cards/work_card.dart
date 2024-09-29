import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/tasks_controller.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/models/work_model.dart';
import 'package:work_adventure/screens/task_screen.dart';

class WorkCard extends StatefulWidget {
  final Work work;
  final int index;
  const WorkCard({super.key, required this.work, required this.index});

  @override
  State<WorkCard> createState() => _WorkCardState();
}

class _WorkCardState extends State<WorkCard> {
  WorkController workController = Get.find<WorkController>();
  TasksController tasksController = Get.find<TasksController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showDeleteMenu(context);
      },
      onTap: () {
        tasksController.fetchTasks(widget.work.id);
        Get.to(() => const TaskScreen());
      },
      child: Card.outlined(
        margin: const EdgeInsets.symmetric(vertical: 5),
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.work.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getTimeAgo(widget.work.createdAt),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.work.description ?? 'No description provided.',
                style: const TextStyle(fontSize: 16),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  void _showDeleteMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Work'),
          content: const Text('Are you sure you want to delete this work?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                workController.deleteWork(widget.work.id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
