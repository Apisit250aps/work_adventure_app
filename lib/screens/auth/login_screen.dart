import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/widgets/ui/forms/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                child: const Text(
                  "Work Adventure!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const LoginForm(),
              const SizedBox(
                height: 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    onTap: () {
                      Get.offAllNamed('/register');
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
