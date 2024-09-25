import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:get/get.dart';
import 'package:work_adventure/screens/auth/login_screen.dart';
import 'package:work_adventure/screens/focus_screen.dart';
import 'package:work_adventure/screens/quest_screen.dart';
import 'package:work_adventure/screens/work_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NavItem(
            icon: Boxicons.bx_home_circle,
            isSelected: selectedIndex == 0,
            onTap: () {
              Get.to(() => const WorkScreen());
            },
          ),
          NavItem(
            icon: Boxicons.bx_receipt,
            isSelected: selectedIndex == 1,
            onTap: () {
              Get.to(() => const QuestScreen());
            },
          ),
          NavItem(
            icon: Boxicons.bx_time_five,
            isSelected: selectedIndex == 2,
            onTap: () {
              Get.to(() => const FocusScreen());
            },
          ),
          NavItem(
            icon: Boxicons.bx_user,
            isSelected: selectedIndex == 3,
            onTap: () {
              Get.to(() => const LoginScreen());
            },
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;

  final bool isSelected;
  final VoidCallback onTap;

  const NavItem({
    super.key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
