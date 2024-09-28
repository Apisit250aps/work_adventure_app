import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/models/character_statistic_model.dart';
import 'package:work_adventure/widgets/button/form_button.dart';
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
  final WorkController workController = Get.put(WorkController());

  bool isLoading = false;

  Future<void> onSubmit() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (_name.text.isEmpty) {
        Get.snackbar("Form invalid", "Please fill in all required fields.");
      } else {
        // Logic to submit the form
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // ใช้ .value เพื่อเข้าถึงค่าจริงของตัวแปร reactive
  late Character character;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _start = TextEditingController();
  final TextEditingController _due = TextEditingController();
  final TextEditingController _status = TextEditingController(text: "Pending");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          const AppBarNav(
            title: "Work",
            actions: [
              IconButton.outlined(
                onPressed: null,
                icon: Icon(Boxicons.bx_menu),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        child: const Icon(Boxicons.bx_message_square_add),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SheetContents(
          children: [
            const SheetHeader(
              title: "New Work",
            ),
            SheetBody(
              children: [
                InputLabel(
                  label: "name",
                  controller: _name,
                ),
                InputLabel(
                  label: "description",
                  controller: _description,
                ),
                DateInputLabel(
                  label: 'Start Date',
                  onDateSelected: (DateTime date) {
                    _start.text = date.toString();
                    print(_start.text);
                  },
                ),
                DateInputLabel(
                  label: 'Due Date',
                  onDateSelected: (DateTime date) {
                    _due.text = date.toString();
                  },
                ),
                Obx(
                  () => Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: ToggleButtons(
                      direction: Axis.horizontal,
                      onPressed: (int index) {
                        workController.updateStatus(index);
                        setState(() {
                          _status.text = workController
                              .status[workController.selectedStatusIndex.value];

                          print(_status.text);
                        });
                      },

                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      selectedBorderColor: Colors.black,
                      selectedColor: Colors.white,
                      fillColor: Colors.black,
                      color: Colors.black,
                      constraints: const BoxConstraints(
                        minHeight: 40.0,
                        minWidth: 80.0,
                      ),
                      isSelected: List.generate(
                          workController.status.length,
                          (i) =>
                              i ==
                              workController.selectedStatusIndex
                                  .value), // ตรวจสอบว่าตัวเลือกใดถูกเลือก
                      children: workController.status.map((status) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: Text(status),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SquareButton(
                  onClick: onSubmit,
                  isLoading: isLoading,
                  buttonText: "Create",
                )
              ],
            )
          ],
        );
      },
    );
  }
}
