import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:work_adventure/models/character_statistic_model.dart';
import 'package:work_adventure/widgets/button/action_button.dart';
import 'package:work_adventure/widgets/form/inputs/datepicker_label.dart';
import 'package:work_adventure/widgets/form/inputs/input_label.dart';
import 'package:work_adventure/widgets/navigate/AppNavBar.dart';
import 'package:work_adventure/widgets/sheets/sheet.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  final UserController user = Get.find();
  final CharacterController characterController = Get.find();

  // ใช้ .value เพื่อเข้าถึงค่าจริงของตัวแปร reactive
  late Character character;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          AppBarNav(
            title: "Work",
            actions: [
              ActionButton(
                icon:Boxicons.bx_message_square_add, // ใส่ไอคอนที่ต้องการ เช่น ไอคอนการเพิ่ม
                onPressed: () {
                  _showBottomSheet(context); // หรือฟังก์ชันอื่น ๆ ที่คุณต้องการ
                },
              )
            ],
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('All tasks are'),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Card.outlined(
                  color: Colors.white,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Title',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '1 day ago',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This is a brief description of the work item. It provides a quick overview of the task or project.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: 50, // จำนวนรายการ
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (BuildContext context) {
        return SheetContents(
          children: [
            const SheetHeader(title: "New Work"),
            SheetBody(
              children: [
                const InputLabel(label: "name"),
                const InputLabel(label: "description"),
                DateInputLabel(
                  label: 'Start Date',
                  onDateSelected: (DateTime date) {
                    print('Selected date: ${date.toString()}');
                    // Do something with the selected date
                  },
                ),
                DateInputLabel(
                  label: 'Due Date',
                  onDateSelected: (DateTime date) {
                    print('Selected date: ${date.toString()}');
                    // Do something with the selected date
                  },
                )
              ],
            )
          ],
        );
      },
    );
  }
}
