// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:work_adventure/controllers/character_controller.dart';
// import 'package:work_adventure/widgets/button/form_button.dart';
// import 'package:work_adventure/widgets/form/inputs/input_label.dart';

// class CreateCharacterForm extends StatefulWidget {
//   final TextEditingController? nameController;
//   final TextEditingController? classNameController;
//   final Function() onSubmit;
//   isload
//   const CreateCharacterForm(
//       {super.key, this.nameController, this.classNameController, required this.onSubmit});

//   @override
//   State<CreateCharacterForm> createState() => _CreateCharacterFormState();
// }

// class _CreateCharacterFormState extends State<CreateCharacterForm> {
  
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(10),
//       child: Column(
//         children: [
//           InputLabel(
//             label: "Character Name",
//             controller: widget.nameController,
//           ),
//           InputLabel(
//             label: "Class name",
//             hintText: "Student",
//             controller: widget.classNameController,
//           ),
//           SquareButton(
//             onClick: widget.onSubmit,
//             isLoading: isLoading,
//             buttonText: "Create",
//           )
//         ],
//       ),
//     );
//   }
// }
