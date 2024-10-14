import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:work_adventure/constant.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Status",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              // color: primaryColor,
              alignment: const Alignment(0, 0),
              child: ClipOval(
                child: Image.asset(
                  "assets/images/characters/dog.png",
                  width: 150,
                  height: 150,
                  fit: BoxFit
                      .cover, // This ensures the image fits within the circle
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Dog",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              "Student",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            upStatusBar("STR", 10),
            upStatusBar("PER", 10),
            upStatusBar("END", 10),
            upStatusBar("CHA", 10),
            upStatusBar("INT", 10),
            upStatusBar("AGI", 10),
            upStatusBar("LUK", 10),
          ],
        ),
      ),
    );
  }

  Widget upStatusBar(String status, int value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 75,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: baseColor, borderRadius: BorderRadius.circular(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(status)],
            ),
          ),
          Container(
            child: Row(
              children: [
                IconButton(
                  style: ButtonStyle(
                      elevation: const WidgetStatePropertyAll(5),
                      backgroundColor: WidgetStatePropertyAll(baseColor)),
                  onPressed: () {},
                  icon: const Icon(Boxicons.bx_minus),
                ),
                Container(
                  width: 75,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 5,
                  ),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("$value")],
                  ),
                ),
                IconButton(
                  style: ButtonStyle(
                      elevation: const WidgetStatePropertyAll(5),
                      backgroundColor: WidgetStatePropertyAll(baseColor)),
                  onPressed: () {},
                  icon: const Icon(Boxicons.bx_plus),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
