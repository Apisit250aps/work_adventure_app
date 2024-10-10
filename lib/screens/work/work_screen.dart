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
          ListView(
            shrinkWrap: true, // ทำให้ ListView ย่อขนาดลง
            physics:
                const NeverScrollableScrollPhysics(), // ปิดการเลื่อนของ ListView
            children: const <Widget>[
              CollapseContent(
                title: "title",
                child: Column(
                  children: [Text("asdasdasdasdasda")],
                ),
              ),
              CollapseContent(
                title: "title",
                child: Column(
                  children: [Text("asdasdasdasdasda")],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
