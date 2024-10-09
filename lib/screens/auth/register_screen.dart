import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:work_adventure/widgets/ui/forms/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
              const RegisterForm(),
              const SizedBox(
                height: 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    onTap: () {
                      Get.offAllNamed('/login');
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
