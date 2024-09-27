import 'package:flutter/material.dart';
import 'package:work_adventure/widgets/navigate/AppNavBar.dart';

class FocusSetupScreen extends StatefulWidget {
  const FocusSetupScreen({super.key});

  @override
  State<FocusSetupScreen> createState() => _FocusSetupScreenState();
}

class _FocusSetupScreenState extends State<FocusSetupScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          AppBarNav(title: "Focus"),
        ],
      ),
    );
  }
}
