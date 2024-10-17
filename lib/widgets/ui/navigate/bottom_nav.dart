import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:work_adventure/constant.dart';

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
      selectedFontSize: 12,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Boxicons.bx_home_heart,
            color: textColor,
          ),
          activeIcon: Icon(
            Boxicons.bxs_home_heart,
            color: textColor,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Boxicons.bx_time,
            color: textColor,
          ),
          activeIcon: Icon(
            Boxicons.bxs_time,
            color: textColor,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Boxicons.bx_receipt,
            color: textColor,
          ),
          activeIcon: Icon(
            Boxicons.bxs_receipt,
            color: textColor,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Boxicons.bx_user,
            color: textColor,
          ),
          activeIcon: Icon(
            Boxicons.bxs_user,
            color: textColor,
          ),
          label: '',
        ),
      ],
    );
  }
}
