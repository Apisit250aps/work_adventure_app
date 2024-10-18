import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/widgets/ui/buttons.dart';

import 'package:work_adventure/widgets/ui/forms/inputs.dart';

class CharacterForm extends StatefulWidget {
  const CharacterForm({super.key});

  @override
  State<CharacterForm> createState() => _CharacterFormState();
}

class _CharacterFormState extends State<CharacterForm> {
  final CharacterController controller = Get.find<CharacterController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController classController = TextEditingController();
  final TextEditingController avatarIndex = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void submit() async {
    if (nameController.text.isEmpty) {
      Get.snackbar("Form invalid", "message");
    } else {
      setState(() {
        _isLoading = true;
      });

      try {
        
        final success = await controller.createCharacter(
            nameController.text, classController.text, int.parse(avatarIndex.text));

        if (!success) {
          setState(() {
            _isLoading = false;
          });
          Get.snackbar("Failed to create character", "message");
          return;
        } else {
          Get.snackbar("Character created successfully", "message");
          Get.offAllNamed("/characters");
        }
      } catch (e) {
        Get.snackbar("Failed to create character", "message");
        return;
      } finally {
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
        margin: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          children: [
            CarouselSlider.builder(
              itemCount: controller.characterImages.length,
              itemBuilder: (context, index, realIndex) {
                final image = controller.characterImages[index];
                return Container(
                  child: Column(
                    children: [
                      Image.asset(
                        image,
                        width: 250,
                      ),
                    ],
                  ),
                );
              },
              options: CarouselOptions(
                aspectRatio: 1,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  avatarIndex.text = "$index";
                  print('???${avatarIndex.text}');
                },
              ),
            ),
            CharacterFormGroup(
              nameController: nameController,
              classController: classController,
            ),
            GradientButton(
              onPressed: submit,
              gradientColors: [
                primaryColor,
                secondaryColor,
              ],
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Create",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class CharacterAvatar extends StatefulWidget {
  final String? name;
  const CharacterAvatar({super.key, this.name});

  @override
  State<CharacterAvatar> createState() => _CharacterAvatarState();
}

class _CharacterAvatarState extends State<CharacterAvatar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      child: Column(
        children: [
          Image.asset('assets/images/characters/dog.png'),
          const SizedBox(
            height: 30,
          ),
          Text(
            widget.name!,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          )
        ],
      ),
    );
  }
}

class CharacterFormGroup extends StatelessWidget {
  final TextEditingController? nameController;
  final TextEditingController? classController;
  const CharacterFormGroup(
      {super.key, this.nameController, this.classController});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 20,
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
