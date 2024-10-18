import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:work_adventure/models/character_model.dart';
import 'package:work_adventure/screens/todo/work_screen.dart';
import 'package:work_adventure/widgets/ui/loading/slime_loading.dart';

class CharacterScreen extends GetView<CharacterController> {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<UserController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text(
          "Character",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadCharacters,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: SlimeLoading(),
            );
          } else if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage.value));
          } else if (controller.charactersSlot.isEmpty) {
            return const Center(child: Text('No characters available'));
          } else {
            return Center(
              child: CarouselSlider.builder(
                itemCount: controller.charactersSlot.length,
                itemBuilder: (context, index, realIndex) {
                  final character = controller.charactersSlot[index];
                  return CharacterCard(
                    character: character,
                    onTap: () {
                      controller.selectIndex(index);
                      Get.toNamed('/operator');
                    },
                  );
                },
                options: CarouselOptions(
                  height: Get.height * 0.5,
                  aspectRatio: 1,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    controller.selectIndex(index);
                  },
                ),
              ),
            );
          }
        }),
      ),
      floatingActionButton: GradientFloatingActionButton(
        onPressed: () {
          Get.toNamed("/characterCreate");
        },
        icon: const Icon(Boxicons.bx_plus, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CharacterCard extends GetWidget<CharacterController> {
  final Character character;
  final VoidCallback? onTap; // รับ onTap เป็นพารามิเตอร์
  final VoidCallback? onDoubleTap;

  const CharacterCard({
    super.key,
    required this.character,
    this.onTap,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: () => editCharacterSheets(character),
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              offset: Offset(0, 5), // corresponds to 0px 10px
              blurRadius: 5, // corresponds to 50px
            )
          ],
        ),
        child: Column(
          children: [
            Image.asset(
              controller.characterImages[character.avatarIndex as int],
              width: 250,
            ),
            const SizedBox(height: 0),
            Text(
              character.name as String,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 24,
              ),
            )
          ],
        ),
      ),
    );
  }

  void editCharacterSheets(character) {
    Get.bottomSheet(const BottomSheetContent());
  }
}

class GradientFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget icon;

  const GradientFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: icon,
      ),
    );
  }
}
