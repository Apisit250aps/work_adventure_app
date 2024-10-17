import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/quest_controller.dart';
import 'package:work_adventure/widgets/ui/buttons.dart';
import 'package:work_adventure/widgets/ui/forms/inputs.dart';

class QuestCreateForm extends StatefulWidget {
  const QuestCreateForm({super.key});

  @override
  State<QuestCreateForm> createState() => _QuestCreateFormState();
}

class _QuestCreateFormState extends State<QuestCreateForm> {
  final QuestController controller = Get.find<QuestController>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController questName = TextEditingController();
  final TextEditingController questDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        width: double.infinity,
        child: Column(
          children: [
            const Text(
              'New Quest',
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
                    controller: questName,
                  ),
                  CustomTextField(
                    hintText: "description",
                    controller: questDescription,
                  ),
                ],
              ),
            ),
            GradientButton(
              onPressed: () {
                // Add logic to save the work sheet
                _submitForm();
              },
              child: const Text(
                'Save Quest',
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      controller
          .addQuest(questName.text, questDescription.text)
          .then((success) {
        if (success) {
          Get.back(); // Close the form
          Get.snackbar('Success', 'Quest created successfully');
        } else {
          Get.snackbar('Error', 'Failed to create quest sheet');
        }
      });
    }
  }
}
