import 'package:flutter/material.dart';

class InputLabel extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool obscureText;

  const InputLabel({
    super.key,
    required this.label,
    this.hintText = '',
    this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade900,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 3,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
