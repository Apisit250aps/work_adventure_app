import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:work_adventure/models/character_model.dart';
import 'package:work_adventure/screens/todo/work_screen.dart';
import 'package:work_adventure/widgets/ui/dialog/custom_confirm_dialog.dart';
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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 50,
                ),
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
  final VoidCallback? onTap;
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
        width: 300,
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor,
              secondaryColor,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 10),
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            controller
                                .characterImages[character.avatarIndex as int],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      character.name as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${character.className} • Level ${character.level}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            'Focus Point: ${character.focusPoint}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editCharacterSheets(Character character) {
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
