import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/screens/auth/login_screen.dart';
import 'package:work_adventure/widgets/form/inputs/input_label.dart';
import 'package:work_adventure/widgets/form/inputs/password_input_label.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          InputLabel(
            label: 'Email',
            // hintText: 'Enter text here',
            controller: TextEditingController(),
          ),
          InputLabel(
            label: 'Username',
            // hintText: 'Enter text here',
            controller: TextEditingController(),
          ),
          PasswordInputLabel(
            label: 'Password',
            // hintText: 'Enter your password',
            controller: TextEditingController(),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(
                  double.infinity,
                  0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
              child: const Text(
                "Register",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Divider(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("I don't have an account! "),
              InkWell(
                child: const Text(
                  "Back to Login",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                ),
                onTap: () {
                  Get.to(() => const LoginScreen());
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
