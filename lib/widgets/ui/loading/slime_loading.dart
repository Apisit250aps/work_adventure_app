import 'package:flutter/material.dart';

class SlimeLoading extends StatefulWidget {
  const SlimeLoading({super.key});

  @override
  State<SlimeLoading> createState() => _SlimeLoadingState();
}

class _SlimeLoadingState extends State<SlimeLoading> {
  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/slime_loading.gif', width: 64,);
  }
}