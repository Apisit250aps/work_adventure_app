import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/constant.dart';
import 'package:work_adventure/screens/operator_screen.dart';

void main() {
  runApp(const WorkAdventure());
}

class WorkAdventure extends StatelessWidget {
  const WorkAdventure({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      home: const OperatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
