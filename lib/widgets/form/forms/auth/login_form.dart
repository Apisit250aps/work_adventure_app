import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/controllers/user_controller.dart';
import 'package:work_adventure/screens/auth/register_screen.dart';
import 'package:work_adventure/screens/work_screen.dart';
import 'package:work_adventure/widgets/form/inputs/input_label.dart';
import 'package:work_adventure/widgets/form/inputs/password_input_label.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();

}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserController userController = Get.find();

  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await userController.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (success) {
        Get.offAll(() => const WorkScreen());
      } else {
        Get.snackbar(
          'Login Failed',
          'Please check your username and password.',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred. Please try again later.',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          InputLabel(
            label: 'Username',
            controller: _usernameController,
          ),
          PasswordInputLabel(
            label: 'Password',
            controller: _passwordController,
          ),
          Container(
            margin: const EdgeInsets.only(top: 25),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                      "Get Started",
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
              const Text("I don't have an account! "),
              InkWell(
                child: const Text(
                  "Go to Register",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                onTap: () {
                  Get.to(() => const RegisterScreen());
                },
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}