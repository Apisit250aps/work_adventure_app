import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/models/work_model.dart';
import 'package:work_adventure/widgets/cards/work_card.dart';
import 'package:work_adventure/widgets/loading/slime_loading.dart';

class WorkListBuilder extends StatelessWidget {
  final List<Work> works;
  const WorkListBuilder({super.key, required this.works});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), 
        itemCount: works.length,
        itemBuilder: (context, index) {
          return WorkCard(
            work: works[index],
            index: index,
          );
        },
      ),
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

    // Future สำหรับการโหลดงานจาก controller
    Future<List<Work>> loadWorks() async {
      // สมมุติว่ามีฟังก์ชันนี้ใน controller
      return await controller.fetchAllWork();
    }

    return FutureBuilder<List<Work>>(
      future: loadWorks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: SlimeLoading());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading works"));
        }
        if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(child: Text("No works available"));
        }
        if (snapshot.hasData) {
          return Flexible(
            flex: 1,
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return WorkCard(
                  work: snapshot.data![index], // ใช้ข้อมูลจาก snapshot
                  index: index,
                );
              },
            ),
          );
        }

        // สถานะเริ่มต้นเมื่อไม่มีข้อมูลอะไร
        return const Center(child: Text("No data available"));
      },
    );
  }
}
