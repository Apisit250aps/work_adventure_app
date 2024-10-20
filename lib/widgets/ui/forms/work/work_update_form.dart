import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/models/work_model.dart';
import 'package:work_adventure/widgets/ui/buttons.dart';
import 'package:work_adventure/widgets/ui/dialog/confirm_dialog.dart';
import 'package:work_adventure/widgets/ui/forms/inputs.dart';

class WorkUpdateForm extends StatefulWidget {
  final Work work;
  final WorkController controller;

  const WorkUpdateForm(
      {super.key, required this.work, required this.controller});

  @override
  _WorkUpdateFormState createState() => _WorkUpdateFormState();
}

class _WorkUpdateFormState extends State<WorkUpdateForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController workNameController;
  late TextEditingController workDescriptionController;
  late TextEditingController workStartController;
  late TextEditingController workDueController;
  late TextEditingController workStatusController;

  @override
  void initState() {
    super.initState();
    workNameController = TextEditingController(text: widget.work.name ?? '');
    workDescriptionController =
        TextEditingController(text: widget.work.description ?? '');
    workStartController =
        TextEditingController(text: widget.work.startDate?.toString() ?? '');
    workDueController =
        TextEditingController(text: widget.work.dueDate?.toString() ?? '');
    workStatusController = TextEditingController(text: widget.work.status);
  }

  @override
  void dispose() {
    workNameController.dispose();
    workDescriptionController.dispose();
    workStartController.dispose();
    workDueController.dispose();
    workStatusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Edit Work',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    offset: Offset(0, 10), // corresponds to 0px 10px
                    blurRadius: 50, // corresponds to 50px
                  )
                ],
              ),
              child: Column(
                children: [
                  CustomTextField(
                    controller: workNameController,
                    hintText: 'Name',
                  ),
                  CustomTextField(
                    controller: workDescriptionController,
                    hintText: 'Description',
                  ),
                  CustomDatePickerField(
                    controller: workStartController,
                    hintText: 'Start Date',
                  ),
                  CustomDatePickerField(
                    controller: workDueController,
                    hintText: 'Due Date',
                  ),
                  CustomSingleSelectToggle(
                    initValue: workStatusController.text,
                    options: widget.controller.status,
                    onSelected: (index) {
                      setState(() {
                        workStatusController.text =
                            widget.controller.status[index];
                        print(workStatusController.text);
                      });
                    },
                    isVertical: false,
                    labelStyle: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Container(
                    width: 48, // ปรับขนาดตามต้องการ
                    height: 48, // ปรับขนาดตามต้องการ
                    margin: const EdgeInsets.only(
                        right: 10), // เพิ่มระยะห่างระหว่างปุ่ม
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red, // หรือสีที่คุณต้องการ
                    ),
                    child: IconButton(
                      icon: const Icon(Boxicons.bx_trash, color: Colors.white),
                      onPressed: () {
                        _confirmDelete(context, widget.work);
                      },
                    ),
                  ),
                  Expanded(
                    child: GradientButton(
                      onPressed: _submitForm,
                      child: const Text(
                        'Save Work',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Work work) async {
    final shouldDelete = await Get.dialog(ConfirmDialog(
        message: "Are you sure you want to delete '${work.name}'",
        icon: "warning",
        onConfirm: () => Get.back(result: true)));

    if (shouldDelete == true) {
      await widget.controller.deleteWork(work.id as String);
      Get.back(); // ปิด BottomSheet
      Get.snackbar("Deleted", 'Work "${work.name}" has been deleted');
    }
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedWork = widget.work.copyWith(
        name: workNameController.text,
        description: workDescriptionController.text,
        startDate: DateTime.tryParse(workStartController.text),
        dueDate: DateTime.tryParse(workDueController.text),
        status: workStatusController.text,
      );

      final success = await widget.controller.updateWork(updatedWork);

      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Work updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update work')),
        );
      }
    }
  }
}
