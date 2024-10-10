import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/widgets/ui/collapses/collapse.dart';

class WorkScreen extends GetView<WorkController> {
  const WorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Obx(
            () {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.workList.isEmpty) {
                return const Center(child: Text('No works available'));
              } else {
                return Expanded(
                  flex: 1,
                  child: ListView.builder(
                    itemCount: controller.workList.length,
                    itemBuilder: (context, index) {
                      final work = controller.workList[index];
                      return CollapseContent(
                        title: work.name as String,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              work.description ?? 'No description available',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
