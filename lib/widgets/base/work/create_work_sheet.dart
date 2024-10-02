import 'package:flutter/material.dart';
import 'package:work_adventure/widgets/form/inputs/input_label.dart';
import 'package:work_adventure/widgets/sheets/sheet.dart';

class CreateWorkSheet extends StatefulWidget {
  const CreateWorkSheet({super.key});

  @override
  State<CreateWorkSheet> createState() => _CreateWorkSheetState();
}

class _CreateWorkSheetState extends State<CreateWorkSheet> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: const Column(
        children: [
          SheetHeader(
            title: 'New Work',
          ),
          CreateWorkForm()
        ],
      ),
    );
  }
}

class CreateWorkForm extends StatefulWidget {
  const CreateWorkForm({super.key});

  @override
  State<CreateWorkForm> createState() => CreateWorkFormState();
}

class CreateWorkFormState extends State<CreateWorkForm> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: const Column(
        children: [
          InputLabel(label: "Name"),
          InputLabel(label: "Description")
        ],
      ),
    );
  }
}
