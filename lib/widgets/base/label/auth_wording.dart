import 'package:flutter/material.dart';

class AuthWording extends StatefulWidget {
  final String heading;
  final String description;
  const AuthWording({
    super.key,
    required this.heading,
    required this.description,
  });

  @override
  State<AuthWording> createState() => _AuthWordingState();
}

class _AuthWordingState extends State<AuthWording> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Text(
            widget.heading,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.description,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
