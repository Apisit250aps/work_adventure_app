import 'package:flutter/material.dart';
import 'package:work_adventure/theme/app_color.dart';

class BadgeComponent extends StatefulWidget {
  final String text;
  final Color bg = AppColors.dark;
  final Color fg = AppColors.base;
  final double fontSize = 14.0;
  const BadgeComponent({super.key, required this.text});

  @override
  State<BadgeComponent> createState() => _BadgeComponentState();
}

class _BadgeComponentState extends State<BadgeComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 2.5,
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: widget.bg,
      ),
      child: Text(
        widget.text, // title
        style: TextStyle(
          color: widget.fg,
          fontSize: widget.fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
