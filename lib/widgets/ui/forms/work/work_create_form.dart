import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/work_controller.dart';
import 'package:work_adventure/widgets/ui/buttons.dart';
import 'package:work_adventure/widgets/ui/forms/inputs.dart';

class WorkCreateForm extends StatefulWidget {
  const WorkCreateForm({super.key});

  @override
  State<WorkCreateForm> createState() => _WorkCreateFormState();
}

class _WorkCreateFormState extends State<WorkCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final WorkController workController = Get.find<WorkController>();

  final TextEditingController workNameController = TextEditingController();
  final TextEditingController workDescriptionController =
      TextEditingController();
  final TextEditingController workStartController = TextEditingController();
  final TextEditingController workDueController = TextEditingController();
  final TextEditingController workStatusController =
      TextEditingController(text: "todo");

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            const Text(
              'Create Work',
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
                    onSelected: (index) {
                      print('$index');
                      print('Selected fruit: ${workController.status[index]}');
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
                // Add logic to save the work sheet
                _submitForm();
              },
              child: const Text(
                'Save Work',
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
    if (_formKey.currentState!.validate()) {
      workController
          .createWork(
        workNameController.text,
        workDescriptionController.text,
        workStartController.text,
        workDueController.text,
        workStatusController.text,
      )
          .then((success) {
        if (success) {
          Get.back(); // Close the form
          Get.snackbar('Success', 'Work sheet created successfully');
        } else {
          Get.snackbar('Error', 'Failed to create work sheet');
        }
      });
    }
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
