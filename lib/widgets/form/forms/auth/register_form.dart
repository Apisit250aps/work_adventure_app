import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:work_adventure/screens/auth/login_screen.dart';
import 'package:work_adventure/widgets/form/inputs/input_label.dart';
import 'package:work_adventure/widgets/form/inputs/password_input_label.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserController userController = Get.find();

  bool _isLoading = false;

  Future<void> _register() async {
    if (!_validateInputs()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = await userController.register(
        _emailController.text,
        _usernameController.text,
        _passwordController.text,
      );

      if (success) {
        Get.snackbar('Success', 'Registration successful!');
        Get.off(() => const LoginScreen());
      } else {
        Get.snackbar('Error', 'Registration failed. Please try again.');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateInputs() {
    if (_emailController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields');
      return false;
    }
    if (!GetUtils.isEmail(_emailController.text)) {
      Get.snackbar('Error', 'Please enter a valid email');
      return false;
    }
    if (_passwordController.text.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters long');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          InputLabel(
            label: 'Email',
            controller: _emailController,

          ),
          InputLabel(
            label: 'Username',
            controller: _usernameController,
          ),
          PasswordInputLabel(
            label: 'Password',
            controller: _passwordController,
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account? "),
              InkWell(
                child: const Text(
                  "Back to Login",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onTap: () => Get.off(() => const LoginScreen()),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
