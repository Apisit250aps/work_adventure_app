import 'package:flutter/material.dart';

class PasswordInputLabel extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;

  const PasswordInputLabel({
    super.key,
    required this.label,
    this.hintText = '',
    this.controller,
  });

  @override
  State<PasswordInputLabel> createState() => _PasswordInputLabelState();
}

class _PasswordInputLabelState extends State<PasswordInputLabel> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: Colors.grey.shade900,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: TextField(
            controller: widget.controller,
            obscureText: _obscureText,
            decoration: InputDecoration(
              hintText: widget.hintText,
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
