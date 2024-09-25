import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/screens/auth/register_screen.dart';
import 'package:work_adventure/widgets/form/inputs/input_label.dart';
import 'package:work_adventure/widgets/form/inputs/password_input_label.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
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
            margin: const EdgeInsets.only(top: 25),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
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
              child: const Text(
                "Get Started",
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
              const Text("I have exist an account! "),
              InkWell(
                child: const Text(
                  "Go to Register",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
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
}
