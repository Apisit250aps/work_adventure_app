import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/tasks_controller.dart';
import 'package:work_adventure/widgets/button/form_button.dart';
import 'package:work_adventure/widgets/form/inputs/datepicker_label.dart';
import 'package:work_adventure/widgets/form/inputs/input_label.dart';

class TaskCreateForm extends StatelessWidget {
  final TextEditingController _difficulty = TextEditingController(text: "1");
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _start = TextEditingController();
  final TextEditingController _due = TextEditingController();

  final TasksController tasksController = Get.find<TasksController>();

  TaskCreateForm({super.key});

  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      child: Column(
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
                  tasksController.updateStatus(index);
                  _difficulty.text = tasksController
                      .status[tasksController.selectedStatusIndex.value];
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
                isSelected: List.generate(tasksController.status.length,
                    (i) => i == tasksController.selectedStatusIndex.value),
                children: ["easy", "medium", "hard"].map((status) {
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
            onClick: () {},
            isLoading: false,
            buttonText: "Create",
          )
        ],
      ),
    );
  }
}
