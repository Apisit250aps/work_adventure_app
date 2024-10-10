import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController? controller;
  final bool obscureText;
  final VoidCallback? onTogglePassword;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.controller,
    this.obscureText = false,
    this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(20),
        hintText: hintText,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText ? Boxicons.bx_hide : Boxicons.bx_show,
                ),
                onPressed: onTogglePassword,
              )
            : null,
      ),
    );
  }
}

class UsernameTextField extends StatelessWidget {
  final TextEditingController? controller;

  const UsernameTextField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: "Username",
      controller: controller,
    );
  }
}

class EmailTextField extends StatelessWidget {
  final TextEditingController? controller;

  const EmailTextField({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: "Email",
      controller: controller,
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  const PasswordTextField({super.key, this.controller});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hintText: "Password",
      isPassword: true,
      obscureText: _obscureText,
      onTogglePassword: _togglePasswordVisibility,
      controller: widget.controller,
    );
  }
}


