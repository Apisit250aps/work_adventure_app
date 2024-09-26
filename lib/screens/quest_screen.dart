import 'package:flutter/material.dart';
import 'package:work_adventure/widgets/navigate/BottomNavBar.dart';

class QuestScreen extends StatefulWidget {
  const QuestScreen({super.key});

  @override
  State<QuestScreen> createState() => _QuestScreenState();
}

class _QuestScreenState extends State<QuestScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: BottomNavBar(
        selectedIndex: 1,
      ),
    );
  }
}
