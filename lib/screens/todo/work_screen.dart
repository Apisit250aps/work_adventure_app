import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/models/task_model.dart';
import 'package:work_adventure/models/work_model.dart';
import 'package:work_adventure/widgets/ui/collapses/collapse.dart';

class WorkScreen extends GetView<WorkController> {
  const WorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshWorks,
      child: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.workList.isEmpty) {
            return const Center(child: Text('No works available'));
          } else {
            return ListView.builder(
              itemCount: controller.workList.length,
              itemBuilder: (context, index) {
                final work = controller.workList[index];
                return CollapseContent(
                  onDoubleTap: () {
                    controller.selectIndex(index);
                    Get.toNamed('/tasks');
                  },
                  onLongPress: () => _showWorkOptions(context, work),
                  title: work.name ?? 'Untitled',
                  child: SizedBox(
                    child: ListView.builder(
                      itemCount: work.tasks?.length ?? 0,
                      itemBuilder: (context, taskIndex) {
                        final task = work.tasks?[taskIndex] as Task;
                        return ListTile(
                          leading: Container(
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                  offset:
                                      Offset(0, 10), // corresponds to 0px 10px
                                  blurRadius: 50, // corresponds to 50px
                                )
                              ],
                            ),
                            child: IconButton(
                              iconSize: 24,
                              padding: const EdgeInsets.all(0),
                              onPressed: () {},
                              icon: const Icon(Boxicons.bx_check),
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                  task.isDone ? secondaryColor : Colors.white,
                                ),
                                elevation: const WidgetStatePropertyAll(
                                  5,
                                ), // ยังคงมี elevation ได้
                              ),
                            ),
                          ),
                          title: Text(
                            task.name,
                            style: TextStyle(
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showWorkOptions(BuildContext context, Work work) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(work.name as String),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.toNamed('/work/${work.id}/edit');
                },
                child: const Text('Edit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _confirmDelete(context, work);
                },
                child:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Work work) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "${work.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.deleteWork(work.id as String);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
