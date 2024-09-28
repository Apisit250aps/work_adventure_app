import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
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
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          child:  Icon(Boxicons.bx_time_five),
        ));
  }
}
