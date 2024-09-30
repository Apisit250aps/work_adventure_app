import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/models/character_model.dart';
import 'package:work_adventure/widgets/builder/character/character_builder.dart';
import 'package:work_adventure/widgets/button/action_button.dart';
import 'package:work_adventure/widgets/button/form_button.dart';
import 'package:work_adventure/widgets/form/inputs/input_label.dart';
import 'package:work_adventure/widgets/navigate/AppNavBar.dart';
import 'package:work_adventure/widgets/sheets/sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final name = TextEditingController();
  final className = TextEditingController();

  final CharacterController characterController =
      Get.put(CharacterController());
  Future<List<Character>> fetchCharacter() async {
    return await characterController.fetchCharacter();
  }

  bool isLoading = false;
  bool isValid = true;

  Future<void> onSubmit() async {
    setState(() {
      isLoading = true;
      isValid = _FormValid();
    });

    try {
      if (isValid) {
        if (className.text.isEmpty) {
          className.text = "Student";
        }
        final success = await characterController.createCharacter(
          name.text,
          className.text,
        );
        if (success) {
          Get.snackbar("Character created!", "Success");
          name.clear();
          className.clear();
        }
      }
    } catch (e) {
      print("$e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool _FormValid() {
    if (name.text.isEmpty) {
      Get.snackbar("Form is't valid!", "Input character name");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          AppBarNav(
            title: "Character",
            actions: [
              ActionButton(
                icon: Boxicons
                    .bx_message_square_add, // ใส่ไอคอนที่ต้องการ เช่น ไอคอนการเพิ่ม
                onPressed: () {
                  _showBottomSheet(context); // หรือฟังก์ชันอื่น ๆ ที่คุณต้องการ
                },
              )
            ],
          ),
          CharacterBuilder(
            characters: fetchCharacter(),
          )
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
            const SheetHeader(
              title: "New Character",
            ),
            SheetBody(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      InputLabel(
                        label: "Character Name",
                        controller: name,
                      ),
                      InputLabel(
                        label: "Class name",
                        hintText: "Student",
                        controller: className,
                      ),
                      SquareButton(
                        onClick: onSubmit,
                        isLoading: isLoading,
                        buttonText: "Create",
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
}


