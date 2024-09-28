import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/models/work_model.dart';
import 'package:work_adventure/widgets/cards/work_card.dart';
import 'package:work_adventure/widgets/loading/slime_loading.dart';

class WorkListBuilder extends StatefulWidget {
  final Future<List<Work>> works;
  const WorkListBuilder({super.key, required this.works});

  @override
  State<WorkListBuilder> createState() => _WorkListBuilderState();
}

class _WorkListBuilderState extends State<WorkListBuilder> {
  final WorkController workController = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Work>>(
      future: widget.works,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(
                child: SlimeLoading(
              width: 32,
            )),
          );
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final works = snapshot.data!;
          if (works.isNotEmpty) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return WorkCard(
                    work: works[index],
                    index: index,
                  );
                },
                childCount: works.length,
              ),
            );
          } else {
            return const SliverToBoxAdapter(
              child: Center(child: Text('No data available.')),
            );
          }
        } else {
          return const SliverToBoxAdapter(
            child: Center(child: Text('No data available.')),
          );
        }
      },
    );
  }
}

class WorkLoader extends StatefulWidget {
  const WorkLoader({super.key});

  @override
  State<WorkLoader> createState() => _WorkLoaderState();
}

class _WorkLoaderState extends State<WorkLoader> {
  @override
  Widget build(BuildContext context) {
    final WorkController controller = Get.find();
    return Obx(() {
      if (controller.isLoading.value) {
        return const SliverFillRemaining(
          child: Center(child: SlimeLoading()),
        );
      }

      // ตรวจสอบว่ามีงานหรือไม่ ถ้าไม่มีสามารถแสดงข้อความว่าไม่มีงาน
      if (controller.allWork.isEmpty) {
        return const SliverToBoxAdapter(
          child: Center(child: Text("No works available")),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return WorkCard(
              work: controller.allWork[index],
              index: index,
            );
          },
          childCount: controller.allWork.length,
        ),
      );
    });
  }
}
