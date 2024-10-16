import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/models/task_model.dart';
import 'package:work_adventure/models/work_model.dart';
import 'package:work_adventure/widgets/ui/collapses/collapse.dart';
import 'package:work_adventure/widgets/ui/forms/work/work_update_form.dart';
import 'package:work_adventure/widgets/ui/loading/slime_loading.dart';

class WorkScreen extends GetView<WorkController> {
  const WorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshWorks,
      child: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: SlimeLoading());
          } else if (controller.workList.isEmpty) {
            return const Center(child: Text('No works available'));
          } else {
            return ListView.builder(
              itemCount: controller.workList.length,
              itemBuilder: (context, index) {
                final Work work = controller.workList[index];
                return CollapseContent(
                  initiallyExpanded: index == 0,
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
                              icon: Icon(
                                Boxicons.bx_check,
                                color:
                                    task.isDone ? Colors.white : Colors.black,
                              ),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.75,
          expand: false,
          builder: (_, controllers) {
            return  WorkUpdateForm(work: work, controller: controller,);
          },
        );
      },
    );
  }

  
}
