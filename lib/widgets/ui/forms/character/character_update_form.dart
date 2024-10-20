import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/models/character_model.dart';
import 'package:work_adventure/widgets/ui/buttons.dart';
import 'package:work_adventure/widgets/ui/dialog/confirm_dialog.dart';
import 'package:work_adventure/widgets/ui/forms/inputs.dart';

class CharacterUpdateForm extends StatefulWidget {
  final Character character; // Add this line to accept a Character object

  const CharacterUpdateForm(
      {super.key, required this.character}); // Update the constructor

  @override
  State<CharacterUpdateForm> createState() => _CharacterFormState();
}

class _CharacterFormState extends State<CharacterUpdateForm> {
  final CharacterController controller = Get.find<CharacterController>();
  late TextEditingController nameController;
  late TextEditingController classController;
  late TextEditingController avatarIndex;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing data if available
    nameController = TextEditingController(text: widget.character.name ?? '');
    classController =
        TextEditingController(text: widget.character.className ?? '');
    avatarIndex =
        TextEditingController(text: widget.character.avatarIndex.toString());
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        Character update = widget.character.copyWith(
          name: nameController.text,
          className: classController.text,
          avatarIndex: int.parse(avatarIndex.text),
        );

        await controller.updateCharacter(update).then((success) {
          Get.back();
        });
      } catch (e) {
        Get.snackbar(
          widget.character == null
              ? "Failed to create character"
              : "Failed to update character",
          e.toString(),
        );
      } finally {
        Get.back();
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 0),
        child: Column(
          children: [
            CarouselSlider.builder(
              itemCount: controller.characterImages.length,
              itemBuilder: (context, index, realIndex) {
                final image = controller.characterImages[index];
                return Image.asset(image, width: 200);
              },
              options: CarouselOptions(
                aspectRatio: 1,
                enlargeCenterPage: true,
                initialPage: int.parse(avatarIndex.text),
                onPageChanged: (index, reason) {
                  print(index);
                  avatarIndex.text = "$index";
                },
              ),
            ),
            CharacterFormGroup(
              nameController: nameController,
              classController: classController,
            ),
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
                        // _confirmDelete(context, widget.work);
                        confirmDelete(widget.character);
                      },
                    ),
                  ),
                  Expanded(
                    child: GradientButton(
                      onPressed: submit,
                      gradientColors: [primaryColor, secondaryColor],
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Save",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
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

  void confirmDelete(Character character) {
    Get.dialog(
      ConfirmDialog(
        message: "Character will delete",
        icon: "warning",
        onConfirm: () => Get.back(),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    classController.dispose();
    avatarIndex.dispose();
    super.dispose();
  }
}

class CharacterFormGroup extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController classController;

  const CharacterFormGroup({
    super.key,
    required this.nameController,
    required this.classController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
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
            controller: nameController,
            hintText: 'Name',
          ),
          CustomTextField(
            controller: classController,
            hintText: 'Class',
          ),
        ],
      ),
    );
  }
}
