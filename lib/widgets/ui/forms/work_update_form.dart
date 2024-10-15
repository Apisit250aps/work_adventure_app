import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/models/work_model.dart';
import 'package:work_adventure/widgets/ui/buttons.dart';
import 'package:work_adventure/widgets/ui/forms/inputs.dart';

class WorkUpdateForm extends StatefulWidget {
  final Work work;

  const WorkUpdateForm({super.key, required this.work});

  @override
  State<WorkUpdateForm> createState() => _WorkUpdateFormState();
}

class _WorkUpdateFormState extends State<WorkUpdateForm> {
  final _formKey = GlobalKey<FormState>();
  final WorkController workController = Get.find<WorkController>();

  late TextEditingController workNameController;
  late TextEditingController workDescriptionController;
  late TextEditingController workStartController;
  late TextEditingController workDueController;
  late TextEditingController workStatusController;

  @override
  void initState() {
    super.initState();
    workNameController = TextEditingController(text: widget.work.name);
    workDescriptionController = TextEditingController(text: widget.work.description);
    workStartController = TextEditingController(text: widget.work.startDate as String);
    workDueController = TextEditingController(text: widget.work.dueDate as String);
    workStatusController = TextEditingController(text: widget.work.status);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            const Text(
              'Update Work',
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
                    offset: Offset(0, 10),
                    blurRadius: 50,
                  )
                ],
              ),
              child: Column(
                children: [
                  CustomTextField(
                    hintText: "name",
                    controller: workNameController,
                  ),
                  CustomTextField(
                    hintText: "description",
                    controller: workDescriptionController,
                  ),
                  CustomDatePickerField(
                    hintText: 'start',
                    controller: workStartController,
                  ),
                  CustomDatePickerField(
                    hintText: 'due',
                    controller: workDueController,
                  ),
                  CustomSingleSelectToggle(
                    options: workController.status,
                    initialSelection: workController.status.indexOf(widget.work.status as String),
                    onSelected: (index) {
                      print('Selected status: ${workController.status[index]}');
                      workStatusController.text = workController.status[index];
                    },
                    isVertical: false,
                    labelStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            GradientButton(
              onPressed: () {
                _submitForm();
              },
              child: const Text(
                'Update Work',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    // if (_formKey.currentState!.validate()) {
    //   workController
    //       .updateWork(
    //     widget.work.id,
    //     workNameController.text,
    //     workDescriptionController.text,
    //     workStartController.text,
    //     workDueController.text,
    //     workStatusController.text,
    //   )
    //       .then((success) {
    //     if (success) {
    //       Get.back(); // Close the form
    //       Get.snackbar('Success', 'Work updated successfully');
    //     } else {
    //       Get.snackbar('Error', 'Failed to update work');
    //     }
    //   });
    // }
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
}