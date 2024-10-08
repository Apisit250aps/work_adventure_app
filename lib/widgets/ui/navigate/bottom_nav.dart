import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Boxicons.bx_home_heart),
          activeIcon: Icon(Boxicons.bxs_home_heart),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Boxicons.bx_time),
          activeIcon: Icon(Boxicons.bxs_time),
          label: '',
        ),
      ],
    );
  }
}
