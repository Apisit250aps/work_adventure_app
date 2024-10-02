import 'package:flutter/material.dart';

class SlimeLoading extends StatelessWidget {
  final double width;
  const SlimeLoading({super.key, this.width = 64});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/gifs/slime_loading.gif', // แสดง GIF ระหว่างโหลด
      width: width,
    );
  }
}
