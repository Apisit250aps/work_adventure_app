import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/models/character_model.dart';
import 'package:work_adventure/widgets/builder/work/work_builder.dart';
import 'package:work_adventure/widgets/button/form_button.dart';
import 'package:work_adventure/widgets/form/inputs/datepicker_label.dart';
import 'package:work_adventure/widgets/form/inputs/input_label.dart';
import 'package:work_adventure/widgets/loading/slime_loading.dart';
import 'package:work_adventure/widgets/sheets/sheet.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  final UserController user = Get.find();
  final CharacterController characterController =
      Get.find<CharacterController>();
  final WorkController workController = Get.find<WorkController>();

  //
  bool isLoading = false;

  // ใช้ .value เพื่อเข้าถึงค่าจริงของตัวแปร reactive
  late Character character;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _start = TextEditingController();
  final TextEditingController _due = TextEditingController();
  final TextEditingController _status = TextEditingController();

  Future<void> onSubmit() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (_name.text.isEmpty) {
        Get.snackbar("Form invalid", "Please fill in all required fields.");
      } else {
        if (_status.text.isEmpty) {
          _status.text = workController.status[0];
        }
        // Logic to submit the form
        final success = await workController.createWork(
          _name.text,
          _description.text,
          _start.text,
          _due.text,
          _status.text,
        );
        if (success) {
          Get.snackbar("Success", "Work created successfully.");
          _name.clear();
          _description.clear();
          _start.clear();
          _due.clear();
          _status.clear();
        } else {
          Get.snackbar("Error", "Failed to create work.");
        }
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: workController.fetchAllWork,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Column(
            children: [
              Obx(() {
                if (workController.isLoading.value) {
                  // Display loading indicator
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: const Center(
                      child: SlimeLoading(),
                    ),
                  );
                }
                if (workController.workList.isEmpty) {
                  // Display no work message
                  return const Center(child: Text("No works available."));
                }
                // Display the list of work items
                return WorkBuilder(works: workController.workList);
              })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context);
        },
        child: const Icon(Boxicons.bx_message_square_add),
      ),
    );
  }

//
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
                      isSelected: List.generate(workController.status.length,
                          (i) => i == workController.selectedStatusIndex.value),
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
