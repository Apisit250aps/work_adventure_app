import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/controllers/character_controller.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:work_adventure/models/character_model.dart';

class CharacterScreen extends GetView<CharacterController> {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: userController.logout,
          )
        ],
      ),
      body: Center(
        child: Obx(() {
          if (controller.charactersSlot.isEmpty) {
            return const Text("No characters found.");
          } else {
            return CarouselSlider.builder(
              itemCount: controller.charactersSlot.length,
              itemBuilder:
                  (BuildContext context, int itemIndex, int pageViewIndex) {
                return GestureDetector(
                  onTap: () {
                    controller.selectIndex(itemIndex);
                    Get.toNamed('/operator');
                  },
                  child: CharacterCard(
                      character: controller.charactersSlot[itemIndex]),
                );
              },
              options: CarouselOptions(
                aspectRatio: 1 / 1,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: false,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
              ),
            );
          }
        }),
      ),
      floatingActionButton: GradientFloatingActionButton(
        onPressed: () {
          // Add your onPressed action here
        },
        icon: const Icon(Boxicons.bx_plus, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Image.asset("assets/images/slime_loading.gif"),
          const SizedBox(height: 10),
          Text(
            character.name as String,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 36,
            ),
          )
        ],
      ),
    );
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
