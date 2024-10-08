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
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Boxicons.bx_home_circle),
          activeIcon: Icon(Boxicons.bxs_home_circle),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Boxicons.bx_time),
          activeIcon: Icon(Boxicons.bxs_time),
          label: 'Focus',
        ),
      ],
    );
  }
}
