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
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: ListView.builder(
                itemCount: controller.workList.length,
                itemBuilder: (context, index) {
                  final Work work = controller.workList[index];
                  return WorkCollapseTileList(work: work, index);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class WorkCollapseTileList extends GetWidget<WorkController> {
  final Work work;
  final int index;
  const WorkCollapseTileList(this.index, {super.key, required this.work});

  @override
  Widget build(BuildContext context) {
    return CollapseContent(
      initiallyExpanded: index == 0,
      onDoubleTap: () {
        controller.selectIndex(index);
        Get.toNamed('/tasks');
      },
      onLongPress: () => _showWorkOptions(work),
      title: work.name ?? 'Untitled',
      child: SizedBox(
        child: ListView.builder(
          itemCount: work.tasks?.length ?? 0,
          itemBuilder: (context, taskIndex) {
            final task = work.tasks?[taskIndex] as Task;
            return TaskOfWork(task: task);
          },
        ),
      ),
    );
  }

  void _showWorkOptions(Work work) {
    Get.bottomSheet(
      isScrollControlled: true,
      BottomSheetContent(
        child: WorkUpdateForm(
          work: work,
          controller: controller,
        ),
      ),
    );
  }
}

class BottomSheetContent extends StatelessWidget {
  final Widget? child;
  final double? height;
  const BottomSheetContent({super.key, this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? Get.height * 0.7,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: SingleChildScrollView(
        child: child,
      ),
    );
  }
}

class TaskOfWork extends StatelessWidget {
  final Task task;
  const TaskOfWork({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        onPressed: () {},
        style: ButtonStyle(
          iconColor: WidgetStatePropertyAll(
            task.isDone ? baseColor : textColor,
          ),
          backgroundColor: WidgetStatePropertyAll(
            task.isDone ? secondaryColor : baseColor,
          ),
        ),
        icon: const Icon(
          Boxicons.bx_check,
        ),
      ),
      title: Text(
        task.name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          decoration: task.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 5,
        ),
        decoration: BoxDecoration(
          color: diffColor(task.difficulty),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          diff(task.difficulty),
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
      // subtitle: Text(task.description ?? ''),
    );
  }

  String diff(int index) {
    List<String> taskDiffs = <String>["Easy", "Medium", "Hard"];
    return taskDiffs[index - 1];
  }

  Color diffColor(int index) {
    List<Color> colors = <Color>[
      Colors.green.shade100,
      Colors.yellow.shade100,
      Colors.red.shade100,
    ];

    return colors[index - 1];
  }
}
